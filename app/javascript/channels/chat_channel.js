import consumer from "./consumer"

// Đây là file mẫu để tham khảo cách kết nối với ChatChannel
// Trong triển khai thực tế, kết nối được tạo trực tiếp từ _chat_assistant.html.erb

/*
const chatChannel = consumer.subscriptions.create(
  {
    channel: "ChatChannel",
    session_id: "session_id_here",
    user_id: "user_id_here",
    user_name: "user_name_here"
  },
  {
    connected() {
      console.log("Đã kết nối với ChatChannel")
    },
    
    disconnected() {
      console.log("Đã ngắt kết nối với ChatChannel")
    },
    
    received(data) {
      // Xử lý dữ liệu nhận được từ server
      console.log("Tin nhắn mới:", data)
    },
    
    send_message(content) {
      // Gọi phương thức send_message của ChatChannel trên server
      this.perform('send_message', { 
        content: content,
        session_id: "session_id_here",
        user_id: "user_id_here",
        user_name: "user_name_here"
      })
    }
  }
)
*/ 