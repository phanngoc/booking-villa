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
    puts("new booking", @booking)
    Rails.logger.debug { @booking.inspect }
  end

  def create
    @booking = @villa.bookings.build(booking_params)
    puts("create booking_params", booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to villa_booking_path(@villa, @booking), notice: "Đặt phòng thành công."
    else
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
    params.require(:booking).permit(:check_in, :check_out)
  end
end
