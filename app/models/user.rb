class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :bookings
  has_many :villas, through: :bookings
  has_many :reviews

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
end
