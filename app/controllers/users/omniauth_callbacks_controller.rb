class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Xử lý callback khi đăng nhập qua Google
  def google_oauth2
    handle_auth "Google"
  end

  private

  def handle_auth(kind)
    # Lấy thông tin xác thực từ request
    Rails.logger.info "OmniAuth request data received: #{request.env["omniauth.auth"].provider}"

    @user = User.from_omniauth(request.env["omniauth.auth"])

    Rails.logger.info "User after from_omniauth: #{@user.inspect}"
    Rails.logger.info "User persisted?: #{@user.persisted?}"

    if @user.persisted?
      # Nếu user đã tồn tại, đăng nhập và chuyển hướng
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      # Nếu không thể tạo user, lưu thông tin OAuth vào session và chuyển hướng đến trang đăng ký
      Rails.logger.info "User not persisted, errors: #{@user.errors.full_messages}"
      session["devise.#{kind.downcase}_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  # Xử lý khi xảy ra lỗi
  def failure
    redirect_to root_path, alert: "Không thể đăng nhập qua #{kind}. Vui lòng thử lại sau."
  end
end
