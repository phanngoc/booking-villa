class VillaAmenity < ApplicationRecord
  belongs_to :villa
  belongs_to :amenity

  validates :villa_id, uniqueness: { scope: :amenity_id, message: "đã có tiện ích này" }
  validates :value, presence: true, if: -> { amenity.require_value }

  # Scope cho việc tìm kiếm
  scope :with_value, ->(value) { where(value: value) }
  scope :with_value_like, ->(value) { where("value ILIKE ?", "%#{value}%") }
end
