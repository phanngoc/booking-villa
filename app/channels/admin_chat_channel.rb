class AdminChatChannel < ApplicationCable::Channel
  def subscribed
    # Tạo một kênh riêng cho admin
    stream_from "admin_chat"
    Rails.logger.info "Admin connected to AdminChatChannel"
  end

  def unsubscribed
    # Dọn dẹp khi ngắt kết nối
    Rails.logger.info "Admin disconnected from AdminChatChannel"
  end

  # Admin gửi tin nhắn đến người dùng
  def admin_reply(data)
    chat_thread_id = data["chat_thread_id"]
    content = data["content"]
    
    # Tìm chat thread
    chat_thread = ChatThread.find_by(id: chat_thread_id)
    return unless chat_thread
    
    # Lưu tin nhắn sử dụng NotificationService
    message = NotificationService.create_message(
      chat_thread,
      content,
      "admin"
    )
    
    # Cập nhật trạng thái của thread
    chat_thread.update(last_activity_at: Time.current)

    # Gửi tin nhắn đến channel của chat thread
    ActionCable.server.broadcast(
      "chat_thread_#{chat_thread.id}",
      {
        action: "new_message",
        message_id: message.id,
        content: message.content,
        sender: message.sender,
        chat_thread_id: chat_thread.id,
        timestamp: message.created_at.to_i
      }
    )
    
    # Gửi thông báo tới admin (để xác nhận gửi thành công)
    ActionCable.server.broadcast(
      "admin_chat",
      {
        action: "message_sent",
        message_id: message.id,
        chat_thread_id: chat_thread.id,
        success: true
      }
    )
  end
  
  # Admin đánh dấu đã đọc tất cả tin nhắn trong một thread
  def mark_thread_as_read(data)
    chat_thread_id = data["chat_thread_id"]
    chat_thread = ChatThread.find_by(id: chat_thread_id)
    return unless chat_thread
    
    # Đánh dấu tất cả tin nhắn từ người dùng là đã đọc
    messages_updated = chat_thread.messages.by_user.unread.update_all(is_read: true)
    chat_thread.update(is_unread: false)
    
    # Thông báo cho admin
    ActionCable.server.broadcast(
      "admin_chat",
      {
        action: "thread_marked_read",
        chat_thread_id: chat_thread.id,
        messages_updated: messages_updated
      }
    )
  end
end
