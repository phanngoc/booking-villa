class PaymentMethod < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  # Relationships
  has_many :payments

  # Scopes
  scope :active, -> { where(active: true) }

  # Methods để sử dụng cho select box
  def self.for_select
    active.pluck(:name, :id)
  end

  def display_name
    name
  end
end
