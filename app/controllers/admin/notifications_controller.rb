class Admin::NotificationsController < ApplicationController
  before_action :authenticate_admin
  layout "admin"

  def index
    @notifications = Notification.newest_first.page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.json { render json: Notification.newest_first.limit(10) }
    end
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.mark_as_read! unless @notification.is_read
    
    # Check if this is a chat message notification and redirect to the chat thread
    if @notification.category == 'user_message' && @notification.reference_type == 'Message'
      if @notification.reference.present?
        # Get the message and its thread
        message = @notification.reference
        chat_thread = message.chat_thread
        
        # Redirect to the chat thread
        return redirect_to admin_chat_path(chat_thread)
      end
    end
    
    # If it's not a chat message or there's an issue, show the notification
    respond_to do |format|
      format.html
      format.json { render json: @notification }
    end
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.mark_as_read!

    respond_to do |format|
      format.html { redirect_to admin_notifications_path, notice: "Th\u00F4ng b\u00E1o \u0111\u00E3 \u0111\u01B0\u1EE3c \u0111\u00E1nh d\u1EA5u l\u00E0 \u0111\u00E3 \u0111\u1ECDc." }
      format.json { render json: { success: true } }
    end
  end

  def mark_all_as_read
    Notification.mark_all_as_read!(current_admin.id)

    respond_to do |format|
      format.html { redirect_to admin_notifications_path, notice: "T\u1EA5t c\u1EA3 th\u00F4ng b\u00E1o \u0111\u00E3 \u0111\u01B0\u1EE3c \u0111\u00E1nh d\u1EA5u l\u00E0 \u0111\u00E3 \u0111\u1ECDc." }
      format.json { render json: { success: true } }
    end
  end

  def count_unread
    count = Notification.unread.count
    render json: { count: count }
  end

  private
end
