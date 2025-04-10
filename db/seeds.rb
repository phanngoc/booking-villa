# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Xóa dữ liệu cũ
puts "Xóa dữ liệu cũ..."
Review.delete_all
Booking.delete_all
VillaAmenity.delete_all
Amenity.delete_all
Villa.delete_all
# User.delete_all

# Load seeds cho Member
load(Rails.root.join('db', 'seeds', 'members.rb'))

# Tạo user đầu tiên
# user = User.create!(
#   email: 'test@example.com',
#   password: 'password',
#   password_confirmation: 'password',
#   name: 'Test User'
# )

# Lấy user đầu tiên
user = User.first
puts "Sử dụng user: #{user.email}"


# Danh sách địa điểm
locations = [
  "Đà Lạt, Lâm Đồng",
  "Nha Trang, Khánh Hòa",
  "Phú Quốc, Kiên Giang",
  "Hội An, Quảng Nam",
  "Sapa, Lào Cai",
  "Vũng Tàu, Bà Rịa - Vũng Tàu",
  "Mũi Né, Bình Thuận",
  "Côn Đảo, Bà Rịa - Vũng Tàu",
  "Tam Đảo, Vĩnh Phúc",
  "Bà Nà Hills, Đà Nẵng"
]

# Danh sách tiện nghi
amenities_list = [
  { name: "Bể bơi vô cực", require_value: false },
  { name: "Bếp đầy đủ tiện nghi", require_value: false },
  { name: "Điều hòa nhiệt độ", require_value: true },
  { name: "WiFi miễn phí", require_value: true },
  { name: "TV màn hình phẳng", require_value: true },
  { name: "Máy giặt", require_value: false },
  { name: "Bãi đỗ xe", require_value: true },
  { name: "Sân vườn", require_value: true },
  { name: "Ban công", require_value: true },
  { name: "Lò sưởi", require_value: false },
  { name: "Bàn ăn ngoài trời", require_value: false },
  { name: "Bếp nướng BBQ", require_value: false },
  { name: "Bàn làm việc", require_value: false },
  { name: "Tủ lạnh", require_value: false },
  { name: "Lò vi sóng", require_value: false }
]

# Tạo amenities
puts "Đang tạo dữ liệu tiện ích..."
amenity_records = amenities_list.map do |amenity_attr|
  Amenity.create!(
    name: amenity_attr[:name],
    require_value: amenity_attr[:require_value]
  )
end

# Lưu tên tiện ích (để dùng sau)
amenity_names = amenity_records.map(&:name)
puts "Đã tạo #{amenity_records.count} tiện ích"

# Danh sách tên villa
villa_names = [
  "Villa Hương Thảo",
  "Villa Hồng Hạc",
  "Villa Phong Lan",
  "Villa Mai Vàng",
  "Villa Cúc Vàng",
  "Villa Hồng Đào",
  "Villa Tử Đằng",
  "Villa Hồng Mai",
  "Villa Hồng Cúc",
  "Villa Hồng Lan",
  "Villa Hồng Thảo",
  "Villa Hồng Hương",
  "Villa Hồng Phong",
  "Villa Hồng Thắm",
  "Villa Hồng Thơm",
  "Villa Hồng Thắng",
  "Villa Hồng Thịnh",
  "Villa Hồng Thọ",
  "Villa Hồng Thọ",
  "Villa Hồng Thọ"
]

puts "Đang tạo dữ liệu mẫu..."

# Tạo 20 villa
20.times do |i|
  # Tạo số lượng tiện nghi ngẫu nhiên (từ 5-10)
  random_amenities_count = rand(5..10)
  random_amenities = amenity_records.sample(random_amenities_count)

  # Tạo giá ngẫu nhiên (từ 1 triệu đến 5 triệu)
  random_price = rand(1_000_000..5_000_000)

  # Tạo số lượng phòng ngẫu nhiên (từ 2-6)
  random_rooms = rand(2..6)

  # Tạo số lượng phòng tắm ngẫu nhiên (từ 1-3)
  random_bathrooms = rand(1..3)

  # Tạo số lượng khách tối đa ngẫu nhiên (từ 4-12)
  random_guests = rand(4..12)

  # Tạo trạng thái ngẫu nhiên (70% available, 30% booked)
  random_status = rand(100) < 70 ? 0 : 1

  # Lưu trữ tên tiện ích để sử dụng trong mô tả
  amenity_names_for_villa = random_amenities.map(&:name)

  villa = Villa.create!(
    name: villa_names[i],
    address: locations.sample,
    price: random_price,
    rooms: random_rooms,
    bathrooms: random_bathrooms,
    max_guests: random_guests,
    status: random_status,
    description: "Biệt thự #{villa_names[i]} là một không gian nghỉ dưỡng tuyệt vời với #{random_rooms} phòng ngủ và #{random_bathrooms} phòng tắm. Villa được trang bị đầy đủ tiện nghi hiện đại và có thể chứa tối đa #{random_guests} khách. #{amenity_names_for_villa.join(', ')}. Đây là lựa chọn hoàn hảo cho kỳ nghỉ của bạn.",
    images: "https://source.unsplash.com/800x600/?villa,#{i}"
  )

  # Tạo VillaAmenity cho mỗi tiện ích được chọn
  random_amenities.each do |amenity|
    # Tạo giá trị phù hợp cho tiện ích
    if amenity.require_value
      case amenity.name
      when "Điều hòa nhiệt độ"
        value = [ "18°C", "20°C", "22°C", "24°C", "26°C" ].sample
      when "WiFi miễn phí"
        value = [ "50 Mbps", "100 Mbps", "200 Mbps", "500 Mbps" ].sample
      when "TV màn hình phẳng"
        value = [ "32 inch", "42 inch", "50 inch", "55 inch", "65 inch" ].sample
      when "Bãi đỗ xe"
        value = [ "#{rand(1..5)} chỗ đậu xe" ].sample
      when "Sân vườn"
        value = [ "#{rand(50..200)}m²" ].sample
      when "Ban công"
        value = [ "Hướng biển", "Hướng núi", "Hướng thành phố", "Hướng vườn" ].sample
      else
        value = "Có"
      end
    else
      value = "Có"
    end

    # Tạo record VillaAmenity
    VillaAmenity.create!(
      villa: villa,
      amenity: amenity,
      value: value
    )
  end

  # Chỉ tạo booking cho villa có trạng thái available
  if villa.available?
    # Tạo một số booking và review ngẫu nhiên cho mỗi villa
    rand(0..3).times do |j|
      # Tạo ngày check-in ngẫu nhiên trong khoảng 1-30 ngày tới, mỗi booking cách nhau 10 ngày
      check_in = (j * 10 + rand(1..5)).days.from_now
      # Tạo ngày check-out ngẫu nhiên trong khoảng 1-3 ngày sau check-in
      check_out = check_in + rand(1..3).days

      booking = Booking.create!(
        villa: villa,
        user: user,
        check_in: check_in,
        check_out: check_out,
        total_price: villa.price * (check_out - check_in).to_i,
        status: :completed
      )

      Review.create!(
        villa: villa,
        user: user,
        booking: booking,
        rating: rand(3..5),
        comment: "Tuyệt vời! Villa rất đẹp và tiện nghi. #{[ 'Chúng tôi sẽ quay lại!', 'Dịch vụ rất tốt!', 'Cảnh quan tuyệt vời!', 'Nhân viên phục vụ nhiệt tình!' ].sample}"
      )
    end
  end

  puts "Đã tạo villa: #{villa.name} với #{random_amenities.count} tiện ích"
end

puts "Hoàn thành! Đã tạo #{Villa.count} villa với dữ liệu mẫu và #{VillaAmenity.count} tiện ích villa."

# Tạo tài khoản admin
puts "Tạo tài khoản quản trị..."

members = [
  {
    email: 'admin@example.com',
    password: 'password123',
    name: 'Quản trị viên',
    role: 'admin'
  },
  {
    email: 'manager@example.com',
    password: 'password123',
    name: 'Quản lý',
    role: 'manager'
  },
  {
    email: 'staff@example.com',
    password: 'password123',
    name: 'Nhân viên',
    role: 'staff'
  }
]

members.each do |member_data|
  member = Member.find_or_initialize_by(email: member_data[:email])
  member.password = member_data[:password]
  member.name = member_data[:name]
  member.role = member_data[:role]
  if member.save
    puts "  Đã tạo thành công tài khoản #{member.role}: #{member.email}"
  else
    puts "  Không thể tạo tài khoản #{member_data[:email]}: #{member.errors.full_messages.join(', ')}"
  end
end

puts "Hoàn thành việc tạo dữ liệu!"

# Thêm các phương thức thanh toán
puts "Creating payment methods..."
payment_methods = [
  {
    name: "Thẻ tín dụng / Thẻ ghi nợ",
    description: "Thanh toán an toàn bằng thẻ tín dụng hoặc thẻ ghi nợ.",
    icon: "/images/payment/credit-card.svg",
    active: true
  },
  {
    name: "Chuyển khoản ngân hàng",
    description: "Chuyển khoản qua ngân hàng nội địa.",
    icon: "/images/payment/bank-transfer.svg",
    active: true
  },
  {
    name: "Tiền mặt khi nhận phòng",
    description: "Thanh toán bằng tiền mặt tại lễ tân khi nhận phòng.",
    icon: "/images/payment/cash.svg",
    active: true
  },
  {
    name: "Solana (SOL)",
    description: "Thanh toán bằng tiền điện tử Solana (SOL).",
    icon: "https://cryptologos.cc/logos/solana-sol-logo.png",
    active: true
  }
]

payment_methods.each do |method|
  PaymentMethod.find_or_create_by!(name: method[:name]) do |pm|
    pm.description = method[:description]
    pm.icon = method[:icon]
    pm.active = method[:active]
  end
end
