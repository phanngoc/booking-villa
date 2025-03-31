class VillasController < ApplicationController
  def index
    @villas = Villa.all
    
    FilterField.active.ordered.each do |field|
      case field.field_type
      when 'text_field'
        @villas = @villas.where("#{field.column_name} ILIKE ?", "%#{params[field.key_query]}%") if params[field.key_query].present?
      
      when 'number_field'
        @villas = @villas.where(field.column_name => params[field.key_query]) if params[field.key_query].present?
      
      when 'dropdown'
        @villas = @villas.where(field.column_name => params[field.key_query]) if params[field.key_query].present?
      
      when 'range_field'
        if params["#{field.key_query}_min"].present?
          @villas = @villas.where("#{field.column_name} >= ?", params["#{field.key_query}_min"])
        end
        if params["#{field.key_query}_max"].present?
          @villas = @villas.where("#{field.column_name} <= ?", params["#{field.key_query}_max"])
        end
      
      when 'checkbox_group'
        if params[field.key_query].present?
          @villas = @villas.where("#{field.column_name} && ARRAY[?]::varchar[]", params[field.key_query])
        end
      
      when 'radio_group'
        @villas = @villas.where(field.column_name => params[field.key_query]) if params[field.key_query].present?
      end
    end
    
    # Áp dụng sắp xếp
    @villas = case params[:sort]
              when 'price_asc'
                @villas.order(price: :asc)
              when 'price_desc'
                @villas.order(price: :desc)
              when 'rating'
                @villas.left_joins(:reviews)
                       .group('villas.id')
                       .order('AVG(reviews.rating) DESC NULLS LAST')
              else
                @villas.order(created_at: :desc)
              end

    @villas = @villas.includes(:reviews)

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
