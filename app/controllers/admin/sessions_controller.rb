class Admin::SessionsController < ApplicationController
  layout "admin"
  
  def new
  end
  
  def create
    member = Member.find_by(email: params[:email])
    
    if member && member.authenticate(params[:password])
      if member.admin?
        # Lưu member_id vào session
        session[:member_id] = member.id
        redirect_to admin_users_path, notice: "Đăng nhập thành công!"
      else
        flash.now[:alert] = "Bạn không có quyền truy cập vào trang quản trị."
        render :new, status: :unauthorized
      end
    else
      flash.now[:alert] = "Email hoặc mật khẩu không chính xác."
      render :new, status: :unauthorized
    end
  end

  def destroy
    # Xóa member_id khỏi session
    session[:member_id] = nil
    redirect_to admin_new_session_path, notice: "Đã đăng xuất khỏi hệ thống quản trị."
  end
end 