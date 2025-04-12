# Lớp service xử lý việc tạo và quản lý thông báo
class NotificationService
  # Tạo thông báo từ tin nhắn người dùng
  # @param chat_thread [ChatThread] thread chat để tạo tin nhắn
  # @param content [String] nội dung tin nhắn
  # @param sender [String] người gửi (user hoặc admin)
  # @return [Message] đối tượng tin nhắn đã được tạo
  def self.create_message(chat_thread, content, sender)
    # Tạo tin nhắn mới trong table messages
    message = Message.create!(
      chat_thread: chat_thread,
      content: content,
      sender: sender,
      is_read: false
    )
    
    # Tạo thông báo nếu tin nhắn gửi bởi người dùng
    if sender == "user"
      create_notification_for_message(message)
    end
    
    return message
  end
  
  # Tạo thông báo liên kết với tin nhắn (không lưu nội dung tin nhắn)
  # @param message [Message] đối tượng tin nhắn đã được tạo
  # @return [Notification] đối tượng thông báo đã được tạo
  def self.create_notification_for_message(message)
    user = message.chat_thread.user
    notification_content = "#{user.email || 'User'}: #{message.content.truncate(50)}"
    
    Notification.create!(
      user_id: User.admin_user&.id || 1,
      content: notification_content, # Lưu một phần nội dung để hiển thị
      category: 'user_message',
      reference_id: message.id,
      reference_type: 'Message',
      is_read: false
    )
  end

  # Đánh dấu tất cả thông báo chưa đọc của một người dùng là đã đọc
  # @param user_id [Integer] ID của người dùng
  # @return [Integer] số lượng thông báo đã được cập nhật
  def self.mark_all_as_read(user_id)
    Notification.where(user_id: user_id, is_read: false).update_all(is_read: true)
  end

  # Đếm số lượng thông báo chưa đọc của một người dùng
  # @param user_id [Integer] ID của người dùng
  # @return [Integer] số lượng thông báo chưa đọc
  def self.count_unread(user_id)
    Notification.where(user_id: user_id, is_read: false).count
  end

  # Lấy thông báo gần đây nhất của một người dùng
  # @param user_id [Integer] ID của người dùng
  # @param limit [Integer] số lượng thông báo cần lấy
  # @return [ActiveRecord::Relation<Notification>] danh sách thông báo
  def self.recent_notifications(user_id, limit = 5)
    Notification.where(user_id: user_id)
               .order(created_at: :desc)
               .limit(limit)
  end
end
