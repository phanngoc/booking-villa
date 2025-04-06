module Devise
  class CustomFailure < Devise::FailureApp
    def respond
      if request.format.html?
        # Ghi log lỗi
        Rails.logger.error("Devise đăng nhập thất bại: #{request.path}, method: #{request.request_method}, format: #{request.format}")
        Rails.logger.error("Thông tin params: #{request.params.inspect}")
        Rails.logger.error("Thông tin lỗi: #{warden_options.inspect}")
        
        # Nếu là POST request đăng nhập và không phải lỗi CSRF token, chuyển hướng về trang đăng nhập với thông báo lỗi
        if request.post? && warden_message != :unconfirmed && warden_message != :csrf_token_expired
          flash[:alert] = i18n_message
          redirect_to send("new_#{scope}_session_path")
        else
          # Xử lý mặc định
          super
        end
      else
        super
      end
    end
  end
end
