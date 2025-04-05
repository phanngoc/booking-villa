class VillasController < ApplicationController
  def index
    @villas = Villa.all

    # Lọc theo địa điểm
    if params[:location].present?
      @villas = @villas.by_location(params[:location])
    end

    # Lọc theo khoảng giá
    if params[:price_range_min].present? && params[:price_range_max].present?
      @villas = @villas.price_range(params[:price_range_min].to_f, params[:price_range_max].to_f)
    end

    # Lọc theo số phòng ngủ
    if params[:rooms].present?
      @villas = @villas.where(rooms: params[:rooms])
    end

    # Lọc theo số phòng tắm
    if params[:bathrooms].present?
      @villas = @villas.where(bathrooms: params[:bathrooms])
    end

    # Lọc theo số khách tối đa
    if params[:max_guests].present?
      @villas = @villas.where(max_guests: params[:max_guests])
    end

    # Lọc theo trạng thái
    if params[:status].present?
      @villas = @villas.where(status: params[:status])
    end

    # Lọc theo tiện ích (lọc có/không)
    if params[:amenities].present?
      amenity_ids = Amenity.where(name: params[:amenities]).pluck(:id)
      @villas = @villas.with_amenities(amenity_ids) if amenity_ids.present?
    end

    # Lọc theo giá trị tiện ích cụ thể
    Amenity.where(require_value: true).each do |amenity|
      param_key = "amenity_#{amenity.id}"
      if params[param_key].present?
        @villas = @villas.with_amenity_value(amenity.id, params[param_key])
      end
    end

    # Áp dụng sắp xếp
    @villas = case params[:sort]
    when "price_asc"
      @villas.order(price: :asc)
    when "price_desc"
      @villas.order(price: :desc)
    when "rating"
      @villas.left_joins(:reviews)
             .group("villas.id")
             .order("AVG(reviews.rating) DESC NULLS LAST")
    else
      @villas.order(created_at: :desc)
    end

    @villas = @villas.includes(:reviews)

    # Lấy danh sách tiện ích để hiển thị trong form filter
    @amenities = Amenity.all

    # Lấy các giá trị cho filter tiện ích có giá trị
    @amenity_values = {}
    Amenity.where(require_value: true).each do |amenity|
      @amenity_values[amenity.id] = VillaAmenity.where(amenity: amenity).select(:value).distinct.pluck(:value)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @villa = Villa.find(params[:id])
    @reviews = @villa.reviews.includes(:user).recent
  end
end
