class Admin::VillasController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_villa, only: %i[edit update]

  def index
    @q = Villa.ransack(params[:q])
    @villas = @q.result.page(params[:page]).per(20)
  end

  def new
    @villa = Villa.new
  end

  def create
    @villa = Villa.new(villa_params)
    if @villa.save
      redirect_to admin_villas_path, notice: "Villa đã được tạo thành công."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @villa.update(villa_params)
      redirect_to admin_villas_path, notice: "Villa đã được cập nhật thành công."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_villa
    @villa = Villa.find(params[:id])
  end

  def villa_params
    params.require(:villa).permit(
      :name, :address, :price, :status, :rooms, :bathrooms, :max_guests,
      :description, :amenities_list
    )
  end
end
