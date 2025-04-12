class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Thêm log debug cho lỗi đăng nhập
  before_action :log_devise_sign_in_error, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  # Helper methods cho Admin namespace
  def current_admin
    @current_admin ||= Member.find_by(id: session[:member_id]) if session[:member_id]
  end
  helper_method :current_admin

  def authenticate_admin
    unless current_admin && current_admin.admin?
      redirect_to admin_new_session_path, alert: "Vui lòng đăng nhập bằng tài khoản quản trị"
    end
  end

  # Bản chỉnh sửa của authenticate_admin với dấu !
  # Được sử dụng trong các controller admin
  def authenticate_admin!
    unless current_admin && current_admin.admin?
      redirect_to admin_new_session_path, alert: "Vui lòng đăng nhập bằng tài khoản quản trị"
    end
  end

  # Ghi log lỗi đăng nhập
  def log_devise_sign_in_error
    if params[:controller] == "devise/sessions" && params[:action] == "create"
      user = User.find_by(email: params[:user][:email])

      # Ghi log thông tin đăng nhập
      if user
        Rails.logger.debug("DEVISE DEBUG - Đăng nhập - Email: #{params[:user][:email]}")

        if !user.confirmed?
          Rails.logger.debug("DEVISE DEBUG - Tài khoản chưa xác thực email")
        elsif !user.valid_password?(params[:user][:password])
          Rails.logger.debug("DEVISE DEBUG - Mật khẩu không chính xác")
        else
          Rails.logger.debug("DEVISE DEBUG - Lỗi khác khi đăng nhập")
        end
      else
        Rails.logger.debug("DEVISE DEBUG - Email không tồn tại: #{params[:user][:email]}")
      end
    end
  end
end
