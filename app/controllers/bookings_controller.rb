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

    # Tạo payment với trạng thái mặc định
    @booking.build_payment(
      status: :pending,
      amount: calculate_total_price(@booking),
      payment_method: :cash # Giá trị mặc định, sẽ được thay đổi ở bước tiếp theo
    )

    if @booking.save
      # Điều hướng đến trang chọn phương thức thanh toán
      redirect_to choose_payment_method_booking_payment_path(@booking, @booking.payment),
                  notice: "Đặt phòng thành công. Vui lòng chọn phương thức thanh toán."
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
      :check_out
    )
  end

  def calculate_total_price(booking)
    return 0 unless booking.check_in && booking.check_out && booking.villa&.price
    days = (booking.check_out - booking.check_in).to_i
    booking.villa.price * days
  end
end
