// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable"
import "channels"

// Khởi tạo App.cable nếu chưa tồn tại
window.App = window.App || {};
App.cable = App.cable || createConsumer();

function createConsumer() {
  return ActionCable.createConsumer();
}

// Chức năng gửi tin nhắn và tạo thông báo
document.addEventListener('DOMContentLoaded', function() {
  // Kiểm tra xem form gửi tin nhắn có tồn tại không
  const messageForm = document.getElementById('contact-form');
  if (messageForm) {
    messageForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const userId = messageForm.dataset.userId;
      const messageContent = document.getElementById('message-content').value;
      
      if (!messageContent.trim()) {
        alert('Vui lòng nhập nội dung tin nhắn!');
        return;
      }
      
      // Gửi tin nhắn đến server
      fetch('/admin/chats/receive_message', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          user_id: userId,
          message: messageContent
        })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // Xóa nội dung tin nhắn sau khi gửi thành công
          document.getElementById('message-content').value = '';
          
          // Hiển thị thông báo thành công
          alert('Tin nhắn của bạn đã được gửi!');
        } else {
          alert('Có lỗi xảy ra khi gửi tin nhắn!');
        }
      })
      .catch(error => {
        console.error('Lỗi:', error);
        alert('Có lỗi xảy ra khi gửi tin nhắn!');
      });
    });
  }
});
