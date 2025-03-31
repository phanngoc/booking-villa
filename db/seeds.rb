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
Villa.delete_all
# User.delete_all

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
  "Bể bơi vô cực",
  "Bếp đầy đủ tiện nghi",
  "Điều hòa nhiệt độ",
  "WiFi miễn phí",
  "TV màn hình phẳng",
  "Máy giặt",
  "Bãi đỗ xe",
  "Sân vườn",
  "Ban công",
  "Lò sưởi",
  "Bàn ăn ngoài trời",
  "Bếp nướng BBQ",
  "Bàn làm việc",
  "Tủ lạnh",
  "Lò vi sóng"
]

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
  random_amenities = amenities_list.sample(rand(5..10))
  
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

  villa = Villa.create!(
    name: villa_names[i],
    address: locations.sample,
    price: random_price,
    rooms: random_rooms,
    bathrooms: random_bathrooms,
    max_guests: random_guests,
    status: random_status,
    amenities: random_amenities.join(','),
    description: "Biệt thự #{villa_names[i]} là một không gian nghỉ dưỡng tuyệt vời với #{random_rooms} phòng ngủ và #{random_bathrooms} phòng tắm. Villa được trang bị đầy đủ tiện nghi hiện đại và có thể chứa tối đa #{random_guests} khách. #{random_amenities.join(', ')}. Đây là lựa chọn hoàn hảo cho kỳ nghỉ của bạn.",
    images: "https://source.unsplash.com/800x600/?villa,#{i}"
  )

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
        comment: "Tuyệt vời! Villa rất đẹp và tiện nghi. #{['Chúng tôi sẽ quay lại!', 'Dịch vụ rất tốt!', 'Cảnh quan tuyệt vời!', 'Nhân viên phục vụ nhiệt tình!'].sample}"
      )
    end
  end

  puts "Đã tạo villa: #{villa.name}"
end

puts "Hoàn thành! Đã tạo #{Villa.count} villa với dữ liệu mẫu."

# Tạo các filter fields
puts "Creating filter fields..."

# Reset sequence và xóa dữ liệu cũ
FilterField.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('filter_fields')

filter_fields = [
  {
    name: "Giá",
    field_type: "range_field",
    key_query: "price_range",
    column_name: "price",
    position: 1,
    active: true
  },
  {
    name: "Số phòng ngủ",
    field_type: "dropdown",
    key_query: "number_of_rooms",
    column_name: "bedrooms",
    options: ["1", "2", "3", "4", "5+"],
    position: 2,
    active: true
  },
  {
    name: "Số phòng tắm",
    field_type: "dropdown",
    key_query: "number_of_bathrooms",
    column_name: "bathrooms",
    options: ["1", "2", "3", "4+"],
    position: 3,
    active: true
  },
  {
    name: "Tiện nghi",
    field_type: "checkbox_group",
    key_query: "amenities",
    column_name: "amenities",
    options: ["Hồ bơi", "BBQ", "Bãi đậu xe", "Ban công", "Bếp", "Máy giặt", "TV", "Wifi"],
    position: 4,
    active: true
  },
  {
    name: "Địa điểm",
    field_type: "text_field",
    key_query: "location",
    column_name: "location",
    position: 5,
    active: true
  },
  {
    name: "Số khách tối đa",
    field_type: "dropdown",
    key_query: "max_guests",
    column_name: "max_guests",
    options: ["2", "4", "6", "8", "10+"],
    position: 6,
    active: true
  },
  {
    name: "Trạng thái",
    field_type: "radio_group",
    key_query: "status",
    column_name: "status",
    options: ["Còn trống", "Đã đặt"],
    position: 7,
    active: true
  }
]

filter_fields.each do |filter_attrs|
  FilterField.find_or_create_by!(key_query: filter_attrs[:key_query]) do |filter|
    filter.assign_attributes(filter_attrs)
  end
end

puts "Created #{FilterField.count} filter fields"
