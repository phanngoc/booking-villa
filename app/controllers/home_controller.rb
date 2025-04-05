class HomeController < ApplicationController
  def index
    print('index: home_controller')
    @villas = Villa.all
    
    # Áp dụng các filter động
    FilterField.active.ordered.each do |field|
      param_key = field.name.parameterize
      
      case field.field_type
      when 'text_field'
        if params[param_key].present?
          @villas = @villas.where("LOWER(#{field.name.downcase}) LIKE ?", "%#{params[param_key].downcase}%")
        end
      
      when 'number_field'
        if params[param_key].present?
          @villas = @villas.where(field.name.downcase => params[param_key])
        end
      
      when 'dropdown'
        if params[param_key].present?
          value = params[param_key]
          # Xử lý trường hợp "5+" hoặc "4+"
          if value.end_with?('+')
            number = value.chomp('+').to_i
            @villas = @villas.where("#{field.name.downcase} >= ?", number)
          else
            @villas = @villas.where(field.name.downcase => value)
          end
        end
      
      when 'range_field'
        min_value = params["#{param_key}_min"]
        max_value = params["#{param_key}_max"]
        
        @villas = @villas.where("#{field.name.downcase} >= ?", min_value) if min_value.present?
        @villas = @villas.where("#{field.name.downcase} <= ?", max_value) if max_value.present?
      
      when 'checkbox_group'
        if params[param_key].present?
          selected_options = Array(params[param_key])
          @villas = @villas.where("#{field.name.downcase} && ?", "{#{selected_options.join(',')}}")
        end
      
      when 'radio_group'
        if params[param_key].present?
          case field.name.downcase
          when 'trạng thái'
            status = params[param_key] == 'Còn trống' ? :available : :booked
            @villas = @villas.where(status: status)
          else
            @villas = @villas.where(field.name.downcase => params[param_key])
          end
        end
      end
    end
    
    @villas = @villas.includes(:reviews).order(created_at: :desc)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end 