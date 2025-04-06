class Member < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin manager staff] }

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :managers, -> { where(role: 'manager') }
  scope :staffs, -> { where(role: 'staff') }

  # Methods
  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def staff?
    role == 'staff'
  end
  
  def role_name
    case role
    when 'admin' then 'Quản trị viên'
    when 'manager' then 'Quản lý'
    when 'staff' then 'Nhân viên'
    else role
    end
  end
end
