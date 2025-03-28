class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_villa, only: [:new, :create]

  def new
    @booking = Booking.new(villa: @villa)
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.villa = @villa
    @booking.total_price = @villa.price * (booking_params[:check_out].to_date - booking_params[:check_in].to_date).to_i

    if @booking.save
      redirect_to @villa, notice: 'Đặt phòng thành công.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_villa
    @villa = Villa.find(params[:villa_id])
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out)
  end
end 