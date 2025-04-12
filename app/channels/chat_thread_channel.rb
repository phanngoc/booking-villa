class ChatThreadChannel < ApplicationCable::Channel
  def subscribed
    # Stream từ một chat thread cụ thể
    chat_thread_id = params[:chat_thread_id]
    if chat_thread_id.present?
      stream_from "chat_thread_#{chat_thread_id}"
    end
  end

  def unsubscribed
    # Bất kỳ dọn dẹp nào cần thiết khi channel hủy đăng ký
    if params[:chat_thread_id].present?
      # Có thể cập nhật trạng thái người dùng trong chat, v.v.
    end
  end

  def send_message(data)
    # Xử lý tin nhắn từ người dùng
    chat_thread = ChatThread.find_by(id: data["chat_thread_id"])

    return unless chat_thread

    # Tạo tin nhắn mới
    message = NotificationService.create_message(
      chat_thread,
      data["content"],
      data["sender"]
    )

    # Broadcast tin nhắn đến tất cả người đăng ký trong thread
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

    # Nếu tin nhắn được gửi bởi người dùng, cũng broadcast đến kênh admin
    if message.by_user?
      ActionCable.server.broadcast(
        "admin_chat",
        {
          action: "new_message",
          message_id: message.id,
          content: message.content,
          sender: message.sender,
          chat_thread_id: chat_thread.id,
          user_name: chat_thread.user&.email || "Khách",
          timestamp: message.created_at.to_i
        }
      )
    end
  end

  def mark_as_read(data)
    # Đánh dấu tất cả tin nhắn là đã đọc trong thread
    chat_thread = ChatThread.find_by(id: data["chat_thread_id"])

    return unless chat_thread

    chat_thread.mark_as_read
    chat_thread.messages.unread.update_all(is_read: true)

    # Thông báo cho admin về việc đánh dấu đã đọc
    ActionCable.server.broadcast(
      "admin_channel",
      {
        action: "marked_as_read",
        chat_thread_id: chat_thread.id
      }
    )
  end
end
