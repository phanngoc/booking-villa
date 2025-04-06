class Villa < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :address, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  # Enums
  enum status: {
    available: 0,
    disabled: 1
  }

  # Relationships
  has_many :bookings
  has_many :reviews
  has_many :users, through: :bookings
  has_many :villa_amenities, dependent: :destroy
  has_many :amenities, through: :villa_amenities

  # Scopes
  scope :available, -> { where(status: :available) }
  scope :price_range, ->(min, max) { where(price: min..max) }
  scope :by_location, ->(location) { where("address ILIKE ?", "%#{location}%") }
  scope :with_amenities, ->(amenity_ids) {
    # Chuyển đổi thành mảng nếu là một giá trị đơn
    ids = Array(amenity_ids)
    # Lọc ra những ID hợp lệ
    ids = ids.compact.map(&:to_i).reject { |id| id.zero? }

    if ids.present?
      joins(:villa_amenities).where(villa_amenities: { amenity_id: ids }).distinct
    else
      all
    end
  }
  scope :with_amenity_value, ->(amenity_id, value) {
    # Chuyển đổi amenity_id sang integer
    id = amenity_id.to_i

    if id.positive? && value.present?
      joins(:villa_amenities).where(villa_amenities: { amenity_id: id, value: value }).distinct
    else
      all
    end
  }

  # Methods
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def total_reviews
    reviews.count
  end

  def amenities_list
    if amenities.is_a?(String)
      amenities.split(",").map(&:strip)
    elsif amenities.nil?
      []
    else
      amenities
    end
  end

  def amenities_list=(value)
    self.amenities = value.is_a?(Array) ? value.join(",") : value
  end

  # Thêm hoặc cập nhật một tiện ích với giá trị cụ thể
  def set_amenity(amenity_id, value)
    villa_amenity = villa_amenities.find_or_initialize_by(amenity_id: amenity_id)
    villa_amenity.value = value
    villa_amenity.save
  end
end
