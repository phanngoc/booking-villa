# Villa Booking

Hệ thống đặt phòng villa trực tuyến được xây dựng bằng Ruby on Rails 7 và Tailwind CSS.

Page list
![seen1.png](seen1.png)

---

Page detail:
![seen2.png](seen2.png)

## Tính năng chính

- 🏠 Quản lý và đặt phòng villa
- 👤 Hệ thống xác thực người dùng (đăng ký, đăng nhập, xác nhận email)
- 📅 Quản lý lịch đặt phòng
- 💰 Hiển thị giá và tính toán tổng tiền
- 📱 Giao diện responsive, thân thiện với người dùng

## Yêu cầu hệ thống

- Ruby 3.0.0 hoặc cao hơn
- Rails 7.0.0 hoặc cao hơn
- PostgreSQL
- Node.js 14+ và Yarn
- Redis (tùy chọn, cho Action Cable)

## Cài đặt

1. Clone repository:
```bash
git clone https://github.com/your-username/villa-booking.git
cd villa-booking
```

2. Cài đặt dependencies:
```bash
bundle install
yarn install
```

3. Thiết lập database:
```bash
rails db:create
rails db:migrate
rails db:seed  # Nếu muốn thêm dữ liệu mẫu
```

4. Cấu hình môi trường:
- Copy file `.env.example` thành `.env`
- Cập nhật các biến môi trường trong `.env`:
  ```
  GMAIL_USERNAME=your-email@gmail.com
  GMAIL_PASSWORD=your-app-specific-password
  ```
  Xem hướng dẫn trong `.env.example` để biết cách lấy App Password từ Google.

5. Khởi động server:
```bash
./bin/dev
```

Truy cập http://localhost:3000 để xem ứng dụng.

## Cấu trúc dự án

```
app/
├── controllers/        # Controllers xử lý logic
├── models/            # Models và quan hệ dữ liệu
├── views/             # Templates và layouts
├── javascript/        # JavaScript và Stimulus controllers
├── assets/           # Assets (CSS, images)
└── mailers/          # Mailer templates
```

## Công nghệ sử dụng

- 🛤 Ruby on Rails 7
- 💅 Tailwind CSS
- 🎨 Hotwire (Turbo & Stimulus)
- 📨 Action Mailer + Gmail SMTP
- 🔐 Devise (Authentication)
- 🗄 PostgreSQL

## Tính năng bảo mật

- Xác thực email khi đăng ký
- Bảo vệ thông tin nhạy cảm với biến môi trường
- CSRF protection
- Secure password hashing
- SQL injection prevention

## Phát triển

1. Tạo nhánh mới cho tính năng:
```bash
git checkout -b feature/your-feature-name
```

2. Commit changes:
```bash
git commit -am 'Add new feature'
```

3. Push to branch:
```bash
git push origin feature/your-feature-name
```

4. Tạo Pull Request

## Testing

Chạy test suite:
```bash
rails test
rails test:system  # For system tests
```

## Deployment

Ứng dụng có thể được deploy lên các nền tảng như:
- Heroku
- DigitalOcean
- AWS
- Google Cloud Platform

## Contributing

1. Fork dự án
2. Tạo nhánh tính năng
3. Commit thay đổi
4. Push to branch
5. Tạo Pull Request

## License

Dự án này được phân phối dưới [MIT License](LICENSE).

## Hỗ trợ

Nếu bạn gặp vấn đề hoặc có câu hỏi:
- Tạo issue trong repository
- Gửi email tới [your-email@example.com]

## Credits

Developed by [Your Name/Team]
