import consumer from "./consumer"

// Kết nối với AdminChatChannel cho admin
const adminChat = consumer.subscriptions.create("AdminChatChannel", {
  connected() {
    console.log("Connected to AdminChatChannel")
  },

  disconnected() {
    console.log("Disconnected from AdminChatChannel")
  },

  // Khi nhận được tin nhắn từ server
  received(data) {
    console.log("AdminChatChannel received:", data)
    
    if (data.action === "new_message") {
      // Hiển thị tin nhắn mới từ người dùng
      this.appendMessage(data)
      
      // Cập nhật số lượng tin nhắn chưa đọc
      this.updateUnreadCount()
    } else if (data.action === "marked_as_read") {
      // Cập nhật UI khi messages được đánh dấu đã đọc
      this.updateThreadReadStatus(data.chat_thread_id)
    }
  },

  // Gửi tin nhắn từ admin đến người dùng
  adminReply(threadId, content) {
    return this.perform("admin_reply", {
      chat_thread_id: threadId,
      content: content,
      admin_id: this.getCurrentAdminId()
    })
  },
  
  // Lấy ID của admin hiện tại
  getCurrentAdminId() {
    // Lấy admin ID từ data attribute trên trang
    return document.querySelector('meta[name="current-admin-id"]')?.content || "1"
  },
  
  // Hiển thị tin nhắn mới vào container
  appendMessage(data) {
    const threadId = data.chat_thread_id
    const messageContainer = document.querySelector(`#chat-thread-${threadId} .chat-messages`)
    
    if (!messageContainer) {
      // Nếu không có container (có thể admin không đang xem thread này)
      // Cập nhật indicator trạng thái unread của thread trong danh sách
      const threadItem = document.querySelector(`#thread-item-${threadId}`)
      if (threadItem) {
        threadItem.classList.add('unread')
        
        // Nếu đang hiển thị số tin nhắn chưa đọc
        const unreadBadge = threadItem.querySelector('.unread-badge')
        if (unreadBadge) {
          const currentCount = parseInt(unreadBadge.textContent || '0')
          unreadBadge.textContent = currentCount + 1
          unreadBadge.classList.remove('d-none')
        }
      }
      return
    }
    
    // Tạo element cho tin nhắn mới
    const messageElement = document.createElement('div')
    messageElement.className = `message ${data.sender === 'user' ? 'user-message' : 'admin-message'}`
    messageElement.id = `message-${data.message_id}`
    
    // Format thời gian
    const timestamp = new Date(data.timestamp * 1000)
    const timeString = timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    
    // Tạo nội dung HTML cho tin nhắn
    messageElement.innerHTML = `
      <div class="message-content">${data.content}</div>
      <div class="message-meta">
        <span class="message-time">${timeString}</span>
        ${data.sender === 'user' ? '<span class="message-sender">Người dùng</span>' : ''}
      </div>
    `
    
    // Thêm tin nhắn vào container
    messageContainer.appendChild(messageElement)
    
    // Scroll xuống dưới cùng
    messageContainer.scrollTop = messageContainer.scrollHeight
  },
  
  // Cập nhật số lượng tin nhắn chưa đọc
  updateUnreadCount() {
    fetch('/admin/chats/unread_count', {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      // Cập nhật badge số lượng tin nhắn chưa đọc
      const chatBadge = document.querySelector('#chat-unread-badge')
      if (chatBadge) {
        if (data.count > 0) {
          chatBadge.textContent = data.count
          chatBadge.classList.remove('d-none')
        } else {
          chatBadge.classList.add('d-none')
        }
      }
    })
  },
  
  // Cập nhật trạng thái đã đọc của thread
  updateThreadReadStatus(threadId) {
    const threadItem = document.querySelector(`#thread-item-${threadId}`)
    if (threadItem) {
      threadItem.classList.remove('unread')
      
      const unreadBadge = threadItem.querySelector('.unread-badge')
      if (unreadBadge) {
        unreadBadge.classList.add('d-none')
      }
    }
  }
})

// Export để có thể sử dụng trong các file khác
export default adminChat
