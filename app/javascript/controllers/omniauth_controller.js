import { Controller } from "@hotwired/stimulus"

// Kết nối với data-controller="omniauth"
export default class extends Controller {
  connect() {
    // Đảm bảo rằng các liên kết OAuth sẽ hoạt động đúng với Turbo
    this.element.querySelectorAll("a[href*='/users/auth/']").forEach(link => {
      link.setAttribute("data-turbo", "false")
    })
  }
} 