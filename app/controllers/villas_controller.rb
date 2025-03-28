class VillasController < ApplicationController
  def index
    @villas = Villa.available
      .includes(:reviews)
      .order(created_at: :desc)

    # Lọc theo giá
    if params[:min_price].present?
      @villas = @villas.where("price >= ?", params[:min_price])
    end
    if params[:max_price].present?
      @villas = @villas.where("price <= ?", params[:max_price])
    end

    # Lọc theo số phòng
    if params[:rooms].present?
      @villas = @villas.where("rooms >= ?", params[:rooms])
    end

    # Lọc theo địa điểm
    if params[:location].present?
      @villas = @villas.by_location(params[:location])
    end

    # Sắp xếp
    case params[:sort]
    when 'price_asc'
      @villas = @villas.order(price: :asc)
    when 'price_desc'
      @villas = @villas.order(price: :desc)
    when 'rating'
      @villas = @villas.left_joins(:reviews)
        .group('villas.id')
        .order('AVG(reviews.rating) DESC NULLS LAST')
    end
  end

  def show
    @villa = Villa.find(params[:id])
    @reviews = @villa.reviews.includes(:user).recent
  end
end
