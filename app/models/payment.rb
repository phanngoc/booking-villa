class Payment < ApplicationRecord
  # Thuộc tính ảo cho việc chuyển đổi - đảm bảo tương thích với mã cũ
  attr_accessor :payment_method

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :transaction_id, uniqueness: true, allow_nil: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    [ "amount", "status", "transaction_id", "created_at", "updated_at", "booking_id", "payment_method_id" ]
  end

  # Class method to get payment methods for dropdowns
  def self.payment_methods_for_select
    PaymentMethod.for_select
  end

  # Enums
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2,
    refunded: 3
  }

  # Relationships
  belongs_to :booking
  belongs_to :payment_method, optional: true

  # Callbacks
  after_save :update_booking_status, if: :saved_change_to_status?
  before_save :convert_payment_method_to_id, if: -> { @payment_method.present? }

  # Các phương thức cũ
  def credit_card?
    payment_method&.name == "credit_card"
  end

  def bank_transfer?
    payment_method&.name == "bank_transfer"
  end

  def cash?
    payment_method&.name == "cash"
  end

  def sol_wallet?
    payment_method&.name == "sol_wallet"
  end

  private

  def update_booking_status
    case status
    when "completed"
      booking.confirmed!
    when "failed"
      booking.cancelled!
    end
  end

  # Phương thức chuyển đổi từ payment_method sang payment_method_id
  def convert_payment_method_to_id
    method_name = case @payment_method
    when 0 then "credit_card"
    when 1 then "bank_transfer"
    when 2 then "cash"
    when 3 then "sol_wallet"
    when String then @payment_method
    else nil
    end

    if method_name
      payment_method_record = ::PaymentMethod.find_by(name: method_name)
      self.payment_method_id = payment_method_record&.id
    end
  end
end
