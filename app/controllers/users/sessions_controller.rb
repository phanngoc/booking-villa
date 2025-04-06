class Users::SessionsController < Devise::SessionsController
  # Tắt CSRF protection cho action create
  skip_before_action :verify_authenticity_token, only: :create
  
  # Ghi đè phương thức create để xử lý đăng nhập
  def create
    # Ghi log thông tin đăng nhập
    Rails.logger.info("Đang xử lý đăng nhập cho user: #{params[:user][:email]}")
    
    # Tạm thời lưu địa chỉ email để hiển thị nếu có lỗi
    self.resource = resource_class.new(sign_in_params)
    
    # Trước khi đăng nhập, kiểm tra xem tài khoản đã xác thực chưa
    user = User.find_by(email: params[:user][:email])
    
    if user && !user.confirmed? && user.confirmation_period_valid?
      Rails.logger.info("User chưa xác thực email: #{user.email}")
      set_flash_message!(:alert, :unconfirmed)
      redirect_to new_user_session_path
      return
    end
    
    # Đăng nhập bình thường
    super
  rescue => e
    Rails.logger.error("Lỗi đăng nhập: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    flash[:alert] = "Đã xảy ra lỗi khi đăng nhập. Vui lòng thử lại."
    redirect_to new_user_session_path
  end
end 