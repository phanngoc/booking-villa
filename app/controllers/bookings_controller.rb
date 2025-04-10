class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_villa, except: [ :my_bookings, :show, :cancel ]
  before_action :set_booking, only: [ :show, :cancel ]
  before_action :authorize_booking_access, only: [ :show, :cancel ]

  def my_bookings
    @bookings = current_user.bookings.includes(:villa).order(created_at: :desc)
  end

  def index
    print("index:", @villa)
    @bookings = @villa.bookings
  end

  def show
    print("show:", @booking)
  end

  def cancel
    if @booking.pending? || @booking.confirmed?
      @booking.cancelled!
      redirect_to my_bookings_path, notice: "Đã hủy đặt phòng thành công."
    else
      redirect_to my_bookings_path, alert: "Không thể hủy đặt phòng này."
    end
  end

  def new
    @booking = @villa.bookings.build
    @booking.build_payment
  end

  def create
    @booking = @villa.bookings.build(booking_params)
    @booking.user = current_user
    print("booking_params", booking_params)
    # Khởi tạo payment với trạng thái mặc định
    # Không gán payment_method_id ở đây, để người dùng chọn ở bước tiếp theo
    @booking.build_payment(
      status: :pending,
      amount: calculate_total_price(@booking)
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
    @booking = Booking.includes(:villa, :payment).find(params[:id])
  end

  def authorize_booking_access
    unless @booking.user == current_user
      redirect_to root_path, alert: "Bạn không có quyền truy cập vào đặt phòng này."
    end
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
