class VillaSearchesController < ApplicationController
  def index
    @villas = Villa.available

    # Lọc theo giá
    if params[:min_price].present? && params[:max_price].present?
      @villas = @villas.price_range(params[:min_price].to_f, params[:max_price].to_f)
    end

    # Lọc theo địa điểm
    if params[:location].present?
      @villas = @villas.by_location(params[:location])
    end

    # Lọc theo tiện ích
    if params[:amenities].present?
      amenity_ids = params[:amenities].split(",").map(&:to_i)
      @villas = @villas.with_amenities(amenity_ids)
    end

    # Lọc theo giá trị tiện ích
    if params[:amenity_filters].present?
      params[:amenity_filters].each do |amenity_id, value|
        @villas = @villas.with_amenity_value(amenity_id, value) if value.present?
      end
    end

    # Phân trang
    @villas = @villas.page(params[:page]).per(12)

    # Định dạng phản hồi
    respond_to do |format|
      format.html
      format.json { render json: @villas }
    end
  end

  def advanced_search
    # Khởi tạo truy vấn ban đầu
    @query = Villa.available

    # Xử lý các điều kiện lọc từ params
    apply_filters

    # Phân trang
    @villas = @query.page(params[:page]).per(12)

    # Lấy tất cả tiện ích cho form tìm kiếm
    @amenities = Amenity.all

    # Định dạng phản hồi
    respond_to do |format|
      format.html
      format.json { render json: @villas }
    end
  end

  private

  def apply_filters
    # Lọc theo giá
    if params[:min_price].present? && params[:max_price].present?
      @query = @query.price_range(params[:min_price].to_f, params[:max_price].to_f)
    end

    # Lọc theo địa điểm
    if params[:location].present?
      @query = @query.by_location(params[:location])
    end

    # Lọc theo tiện ích (có/không có)
    if params[:amenities].present?
      amenity_ids = params[:amenities].split(",").map(&:to_i)
      @query = @query.with_amenities(amenity_ids)
    end

    # Lọc theo giá trị tiện ích
    if params[:amenity_filters].present?
      params[:amenity_filters].each do |amenity_id, value|
        @query = @query.with_amenity_value(amenity_id, value) if value.present?
      end
    end

    # Sắp xếp kết quả
    apply_sorting
  end

  def apply_sorting
    case params[:sort]
    when "price_asc"
      @query = @query.order(price: :asc)
    when "price_desc"
      @query = @query.order(price: :desc)
    when "rating"
      @query = @query.left_joins(:reviews).group(:id).order("AVG(reviews.rating) DESC NULLS LAST")
    when "newest"
      @query = @query.order(created_at: :desc)
    else
      @query = @query.order(created_at: :desc)
    end
  end
end
