class Booking < ApplicationRecord
  # Validations
  validates :check_in, :check_out, :total_price, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :villa_available
  validate :no_overlapping_bookings

  # Enums
  enum status: {
    pending: 0,
    confirmed: 1,
    completed: 2,
    cancelled: 3
  }

  # Relationships
  belongs_to :user
  belongs_to :villa
  has_one :payment, dependent: :destroy
  has_one :review

  # Nested attributes
  accepts_nested_attributes_for :payment

  # Callbacks
  before_validation :calculate_total_price
  after_create :ensure_payment_exists

  # Scopes
  scope :upcoming, -> { where("check_in >= ?", Date.current) }
  scope :past, -> { where("check_out < ?", Date.current) }
  scope :current, -> { where("check_in <= ? AND check_out >= ?", Date.current, Date.current) }

  private

  def calculate_total_price
    return unless check_in && check_out && villa&.price
    days = (check_out - check_in).to_i
    self.total_price = villa.price * days
  end

  def villa_available
    return unless villa && check_in && check_out
    unless villa.available?
      errors.add(:base, "Villa không khả dụng cho thời gian này")
    end
  end

  def no_overlapping_bookings
    return unless villa && check_in && check_out
    overlapping = villa.bookings.where.not(id: id).where(
      "(check_out >= ?) AND (check_in <= ?)",
      check_in, check_out
    )

    if overlapping.exists?
      errors.add(:base, "Villa đã được đặt cho thời gian này")
    end
  end

  def ensure_payment_exists
    # Nếu payment đã được tạo qua nested attributes, cập nhật amount và status
    if payment
      payment.update(
        amount: total_price,
        status: :pending
      ) unless payment.persisted?
    else
      # Nếu không, tạo mới payment với giá trị mặc định
      create_payment(
        amount: total_price,
        status: :pending,
        payment_method: :cash # Mặc định là thanh toán tiền mặt
      )
    end
  end
end
