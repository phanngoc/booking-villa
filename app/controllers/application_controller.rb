class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
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
end
