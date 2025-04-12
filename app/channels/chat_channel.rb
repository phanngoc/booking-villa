class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Tạo phòng chat riêng dựa trên session_id
    stream_from "chat_#{params[:session_id]}"

    # Thông báo admin có người dùng mới kết nối
    ActionCable.server.broadcast(
      "admin_chat",
      {
        action: "new_session",
        session_id: params[:session_id],
        user_id: params[:user_id],
        user_name: params[:user_name],
        timestamp: Time.now.to_i
      }
    )

    # Lưu thông tin phiên chat vào database (tùy chọn)
    # ChatSession.create(
    #   session_id: params[:session_id],
    #   user_id: params[:user_id],
    #   user_name: params[:user_name],
    #   status: "active"
    # )
  end

  def unsubscribed
    # Thông báo admin người dùng đã ngắt kết nối
    ActionCable.server.broadcast(
      "admin_chat",
      {
        action: "session_closed",
        session_id: params[:session_id],
        user_id: params[:user_id],
        timestamp: Time.now.to_i
      }
    )

    # Cập nhật trạng thái phiên chat (tùy chọn)
    # chat_session = ChatSession.find_by(session_id: params[:session_id])
    # chat_session.update(status: "closed") if chat_session
  end

  def send_message(data)
    # Lưu tin nhắn vào database (tùy chọn)

    # Tạo thông báo nếu người dùng đã đăng nhập
    notification = nil
    if data["user_id"].present? && !data["user_id"].to_s.start_with?("guest_")
      begin
        user_id = data["user_id"].to_i
        user = User.find_by(id: user_id)

        # Tìm hoặc tạo chat thread cho user
        if user.present?
          chat_thread = ChatThread.find_or_create_by(user_id: user_id) do |thread|
            thread.title = "Hỗ trợ cho #{user.email || 'User'}"
            thread.status = "active"
            thread.last_activity_at = Time.current
          end

          # Tạo tin nhắn và thông báo
          if chat_thread.present?
            notification = NotificationService.create_message(
              chat_thread,
              data["content"],
              "user"  # Sử dụng "user" thay vì "user_message"
            )

            Rails.logger.info "Đã tạo tin nhắn và thông báo cho user #{user_id}"
          else
            Rails.logger.error "Không thể tạo chat thread cho user #{user_id}"
          end
        else
          Rails.logger.error "Không tìm thấy user với id #{user_id}"
        end
      rescue => e
        Rails.logger.error "Lỗi khi xử lý tin nhắn: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    # Gửi tin nhắn của người dùng đến admin
    ActionCable.server.broadcast(
      "admin_chat",
      {
        action: "new_message",
        message: data["content"],
        session_id: data["session_id"],
        user_id: data["user_id"],
        user_name: data["user_name"],
        sender_type: "user",
        timestamp: Time.now.to_i,
        notification_id: notification&.id
      }
    )
  end

  def admin_reply(data)
    # Lưu tin nhắn admin vào database (tùy chọn)
    # Message.create(
    #   content: data["content"],
    #   session_id: data["session_id"],
    #   admin_id: data["admin_id"],
    #   sender_type: "admin"
    # )

    # Gửi tin nhắn của admin đến người dùng
    ActionCable.server.broadcast(
      "chat_#{data['session_id']}",
      {
        message: data["content"],
        sender_type: "admin",
        timestamp: Time.now.to_i
      }
    )
  end
end
