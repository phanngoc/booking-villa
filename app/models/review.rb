class Review < ApplicationRecord
  # Validations
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 500 }
  validate :booking_completed

  # Relationships
  belongs_to :user
  belongs_to :villa
  belongs_to :booking

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :high_rated, -> { where("rating >= 4") }

  private

  def booking_completed
    return unless booking
    unless booking.completed?
      errors.add(:base, "Chỉ có thể đánh giá sau khi đã hoàn thành đặt phòng")
    end
  end
end
