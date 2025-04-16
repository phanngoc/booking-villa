class Admin::VillaMetafieldsController < AdminController
  before_action :set_villa
  before_action :set_metafield, only: [:edit, :update, :destroy]

  def index
    @metafields = @villa.metafields.order(:namespace, :position, :key)
    @namespaces = @villa.metafields.pluck(:namespace).uniq
  end

  def new
    @metafield = @villa.metafields.new
  end

  def create
    @metafield = @villa.metafields.new(metafield_params)
    
    if @metafield.save
      redirect_to admin_villa_metafields_path(@villa), notice: "Metafield đã được tạo thành công."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @metafield.update(metafield_params)
      redirect_to admin_villa_metafields_path(@villa), notice: "Metafield đã được cập nhật thành công."
    else
      render :edit
    end
  end

  def destroy
    @metafield.destroy
    redirect_to admin_villa_metafields_path(@villa), notice: "Metafield đã được xóa thành công."
  end

  private

  def set_villa
    @villa = Villa.find(params[:villa_id])
  end

  def set_metafield
    @metafield = @villa.metafields.find(params[:id])
  end

  def metafield_params
    params.require(:villa_metafield).permit(:namespace, :key, :value_type, :value, :visible_on_frontend, :position)
  end
end
