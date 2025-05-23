class Admin::BookingsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin
  before_action :set_booking, only: [ :show, :edit, :update, :destroy ]

  def index
    @q = Booking.ransack(params[:q])
    @bookings = @q.result(distinct: true)
      .includes(:user, :villa, :payment)
      .order(created_at: :desc)
      .page(params[:page])
      .per(10)
  end

  def show
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to admin_booking_path(@booking), notice: "Cập nhật đặt phòng thành công."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to admin_bookings_path, notice: "Đã xóa đặt phòng."
  end

  private

  def set_booking
    @booking = Booking.includes(:payment).find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:status, :check_in, :check_out, :total_price)
  end
end
