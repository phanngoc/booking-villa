import { Controller } from "@hotwired/stimulus"

// Kết nối với data-controller="logout"
export default class extends Controller {
  connect() {
    // Theo dõi sự kiện gửi form khi đăng xuất thành công
    this.element.addEventListener("turbo:submit-end", this.handleLogout.bind(this))
  }

  disconnect() {
    // Loại bỏ sự kiện khi controller bị huỷ
    this.element.removeEventListener("turbo:submit-end", this.handleLogout.bind(this))
  }

  handleLogout(event) {
    // Chỉ xử lý khi form được gửi thành công
    if (event.detail.success) {
      // Tải lại trang để đảm bảo trạng thái đăng xuất được cập nhật
      window.location.href = "/"
    }
  }
} 