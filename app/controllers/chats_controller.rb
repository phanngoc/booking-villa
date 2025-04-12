class ChatsController < ApplicationController
  before_action :set_chat_thread, only: [ :show ]

  # GET /chats
  # Giao diện chat cho người dùng và API endpoint lấy chat thread
  def index
    # Tìm hoặc tạo chat thread cho người dùng hiện tại
    @chat_thread = find_or_create_chat_thread
    
    # Cập nhật thời gian hoạt động cuối
    @chat_thread.update(last_activity_at: Time.current) unless @chat_thread.new_record?

    # Lấy danh sách tin nhắn của thread
    @messages = @chat_thread.messages.order(created_at: :asc)
    
    # Trả về dữ liệu theo định dạng được yêu cầu
    respond_to do |format|
      format.html # Hiển thị giao diện HTML
      format.json do
        render json: {
          chat_thread: @chat_thread,
          messages: @messages
        }
      end
    end
  end

  # GET /chat/:id
  # Xem một cuộc trò chuyện cụ thể
  def show
    @messages = @chat_thread.messages.order(created_at: :asc)

    # Đánh dấu tất cả tin nhắn là đã đọc khi người dùng xem
    @chat_thread.mark_as_read if @chat_thread.user_id == current_user&.id
  end

  # POST /chat/create_message
  # API tạo tin nhắn mới
  def create_message
    content = params[:content]
    
    # Get or create the chat thread for the current user
    if params[:chat_thread_id].present?
      # Use existing thread if provided
      @chat_thread = ChatThread.find(params[:chat_thread_id])
    else
      # Create a new thread if none exists
      @chat_thread = find_or_create_chat_thread
    end

    # Create the message and notification using NotificationService
    sender = current_user ? "user" : "guest"
    @message = NotificationService.create_message(@chat_thread, content, sender)
    
    # Broadcast via ActionCable if configured
    broadcast_message(@message) if defined?(ActionCable)

    respond_to do |format|
      format.json { render json: @message, status: :created }
      format.html { redirect_to chat_path(@chat_thread) }
    end
  end

  private

  def set_chat_thread
    @chat_thread = ChatThread.find(params[:id])
  end
  
  def find_or_create_chat_thread
    if current_user
      # Find or create a thread for authenticated user
      ChatThread.find_or_create_by(
        user: current_user,
        status: "active"
      ) do |thread|
        thread.title = "Hỗ trợ cho #{current_user.email}"
        thread.is_unread = false
        thread.last_activity_at = Time.current
      end
    else
      # Create a thread for guest user
      session[:guest_id] ||= "guest_#{SecureRandom.hex(10)}"
      ChatThread.find_or_create_by(
        user_id: User.guest_user&.id || User.first&.id,
        status: "active",
        title: "Khách #{session[:guest_id]}"
      ) do |thread|
        thread.is_unread = false
        thread.last_activity_at = Time.current
      end
    end
  end
  
  def broadcast_message(message)
    begin
      ActionCable.server.broadcast(
        "chat_thread_#{message.chat_thread_id}",
        {
          action: "new_message",
          message: message.as_json(methods: [:by_user?, :by_admin?]),
          thread_id: message.chat_thread_id
        }
      )
    rescue => e
      Rails.logger.error("Failed to broadcast message: #{e.message}")
    end
  end
end
