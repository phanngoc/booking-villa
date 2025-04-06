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

puts "Hoàn thành việc tạo tài khoản quản trị!" 