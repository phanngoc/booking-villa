class Payment < ApplicationRecord
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :status, presence: true
  validates :transaction_id, uniqueness: true, allow_nil: true

  # Enums
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2,
    refunded: 3
  }

  enum payment_method: {
    credit_card: 0,
    bank_transfer: 1,
    cash: 2,
    sol_wallet: 3
  }

  # Relationships
  belongs_to :booking

  # Callbacks
  after_save :update_booking_status, if: :saved_change_to_status?

  private

  def update_booking_status
    case status
    when "completed"
      booking.confirmed!
    when "failed"
      booking.cancelled!
    end
  end
end
