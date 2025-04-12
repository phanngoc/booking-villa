class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :bookings
  has_many :villas, through: :bookings
  has_many :reviews
  has_many :notifications, dependent: :destroy
  has_many :chat_threads, dependent: :nullify

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    [ "email", "name", "created_at", "updated_at", "id" ]
  end

  # Phương thức xử lý đăng nhập thông qua OAuth
  def self.from_omniauth(auth)
    Rails.logger.info "OmniAuth data: #{auth.to_json}"

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      Rails.logger.info "Creating or updating user with email: #{auth.info.email}"
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.skip_confirmation!

      Rails.logger.info "User valid: #{user.valid?}"
      Rails.logger.info "User errors: #{user.errors.full_messages}" if user.invalid?
    end
  end

  def self.guest_user
    # Tìm hoặc tạo user hệ thống cho khách
    @guest_user ||= User.find_or_create_by(email: "guest@example.com") do |user|
      user.username = "Guest User"
    end
  end
  
  # Identify the admin user for notifications
  def self.admin_user
    # Find admin user based on role if your system has roles
    # admin = User.find_by(role: 'admin')
    
    # If no role system is set up, you can use a predetermined admin email
    admin = User.find_by(email: 'admin@example.com')
    
    # If no admin is found, take the first user (commonly admin in new systems)
    admin ||= User.first
    
    return admin
  end
end
