class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_villa, except: [ :my_bookings ]
  before_action :set_booking, only: [ :show ]

  def my_bookings
    @bookings = current_user.bookings.includes(:villa).order(created_at: :desc)
  end

  def index
    @bookings = @villa.bookings
  end

  def show
  end

  def new
    @booking = @villa.bookings.build
    @booking.build_payment
  end

  def create
    @booking = @villa.bookings.build(booking_params)
    @booking.user = current_user

    # Đảm bảo payment có đầy đủ thông tin
    if @booking.payment
      @booking.payment.amount = calculate_total_price(@booking)
      @booking.payment.status = :pending
    end

    if @booking.save
      # Chuyển hướng dựa vào phương thức thanh toán
      if @booking.payment.sol_wallet?
        redirect_to sol_payment_booking_payment_path(@booking, @booking.payment)
      else
        redirect_to villa_booking_path(@villa, @booking), notice: "Đặt phòng thành công."
      end
    else
      # Đảm bảo payment object tồn tại nếu có lỗi
      @booking.build_payment if @booking.payment.nil?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_villa
    @villa = Villa.find(params[:villa_id])
  end

  def set_booking
    @booking = @villa.bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :check_in,
      :check_out,
      payment_attributes: [ :payment_method, :amount, :status ]
    )
  end

  def calculate_total_price(booking)
    return 0 unless booking.check_in && booking.check_out && booking.villa&.price
    days = (booking.check_out - booking.check_in).to_i
    booking.villa.price * days
  end
end
