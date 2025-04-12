class AdminChannel < ApplicationCable::Channel
  def subscribed
    # Admin đăng ký để nhận tất cả các thông báo
    stream_from "admin_channel"
  end

  def unsubscribed
    # Dọn dẹp khi admin ngắt kết nối
  end

  def admin_reply(data)
    chat_thread = ChatThread.find_by(id: data["chat_thread_id"])

    return unless chat_thread

    # Tạo tin nhắn mới từ admin
    message = chat_thread.messages.create!(
      content: data["content"],
      sender: "admin",
      is_read: true  # Tin nhắn từ admin được đánh dấu là đã đọc
    )

    # Broadcast tin nhắn đến người dùng trong chat thread
    ActionCable.server.broadcast(
      "chat_thread_#{chat_thread.id}",
      {
        action: "new_message",
        message_id: message.id,
        content: message.content,
        sender: message.sender,
        timestamp: message.created_at.to_i
      }
    )

    # Cũng broadcast cho admin để cập nhật giao diện
    ActionCable.server.broadcast(
      "admin_channel",
      {
        action: "admin_reply_sent",
        chat_thread_id: chat_thread.id,
        message_id: message.id
      }
    )
  end

  def close_thread(data)
    chat_thread = ChatThread.find_by(id: data["chat_thread_id"])

    return unless chat_thread

    chat_thread.close

    # Thông báo đến người dùng
    ActionCable.server.broadcast(
      "chat_thread_#{chat_thread.id}",
      {
        action: "thread_closed",
        chat_thread_id: chat_thread.id
      }
    )

    # Thông báo đến admin
    ActionCable.server.broadcast(
      "admin_channel",
      {
        action: "thread_closed",
        chat_thread_id: chat_thread.id
      }
    )
  end
end
