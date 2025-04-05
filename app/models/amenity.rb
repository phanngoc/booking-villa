class Amenity < ApplicationRecord
  has_many :villa_amenities, dependent: :destroy
  has_many :villas, through: :villa_amenities

  validates :name, presence: true, uniqueness: true

  # Scope để lấy tất cả các villa có tiện ích này
  scope :with_value, ->(value) { joins(:villa_amenities).where(villa_amenities: { value: value }).distinct }

  # Phương thức để tìm tất cả các giá trị phổ biến của tiện ích này
  def common_values
    villa_amenities.select(:value).distinct.pluck(:value)
  end
end
