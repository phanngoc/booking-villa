class FilterField < ApplicationRecord
  validates :name, presence: true
  validates :field_type, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  validates :key_query, presence: true, uniqueness: true, format: { with: /\A[a-z0-9_]+\z/, message: "chỉ cho phép chữ thường, số và dấu gạch dưới" }
  validates :column_name, presence: true, format: { with: /\A[a-z0-9_]+\z/, message: "chỉ cho phép chữ thường, số và dấu gạch dưới" }

  serialize :options, Array

  before_validation :set_default_values

  enum field_type: {
    text_field: 'text',
    number_field: 'number',
    dropdown: 'select',
    range_field: 'range',
    checkbox_group: 'checkbox',
    radio_group: 'radio'
  }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc) }
  
  def options_array
    options.reject(&:blank?)
  end

  private

  def set_default_values
    self.key_query = name.parameterize.underscore if key_query.blank?
    self.column_name = key_query if column_name.blank?
  end
end
