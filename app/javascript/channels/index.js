// Tải tất cả các kênh trong thư mục này
import { createConsumer } from "@rails/actioncable"
import "./consumer"
import "./chat_channel"

// Khởi tạo consumer cho ActionCable
window.App = window.App || {};
window.App.cable = window.App.cable || createConsumer(); import "channels/chat_thread_channel"
import "channels/admin_channel"
