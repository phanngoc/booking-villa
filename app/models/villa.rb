class Villa < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :address, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  # Enums
  enum status: {
    available: 0,
    booked: 1,
    maintenance: 2
  }

  # Relationships
  has_many :bookings
  has_many :reviews
  has_many :users, through: :bookings

  # Scopes
  scope :available, -> { where(status: :available) }
  scope :price_range, ->(min, max) { where(price: min..max) }
  scope :by_location, ->(location) { where("address ILIKE ?", "%#{location}%") }

  # Methods
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def total_reviews
    reviews.count
  end
end
