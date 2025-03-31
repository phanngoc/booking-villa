class Admin::FilterFieldsController < ApplicationController
  before_action :set_filter_field, only: [:edit, :update, :destroy]

  def index
    @filter_fields = FilterField.ordered
  end

  def new
    @filter_field = FilterField.new
  end

  def create
    @filter_field = FilterField.new(filter_field_params)
    if @filter_field.save
      redirect_to admin_filter_fields_path, notice: 'Filter field was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @filter_field.update(filter_field_params)
      redirect_to admin_filter_fields_path, notice: 'Filter field was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @filter_field.destroy
    redirect_to admin_filter_fields_path, notice: 'Filter field was successfully deleted.'
  end

  private

  def set_filter_field
    @filter_field = FilterField.find(params[:id])
  end

  def filter_field_params
    params.require(:filter_field).permit(:name, :field_type, :options, :active, :position)
  end
end
