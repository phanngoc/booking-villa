namespace :db do
  namespace :seed do
    desc "Chỉ chạy seeds/members.rb để tạo dữ liệu thành viên"
    task members: :environment do
      puts "Đang chạy seed cho members..."
      load(Rails.root.join('db', 'seeds', 'members.rb'))
      puts "Hoàn thành việc seed members!"
    end
  end
end 