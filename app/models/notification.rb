class Notification < ApplicationRecord
  # Quan hệ
  belongs_to :user
  belongs_to :reference, polymorphic: true, optional: true

  # Validations
  validates :content, presence: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    [ "content", "is_read", "category", "created_at", "updated_at", "user_id", "reference_id", "reference_type" ]
  end

  # Scopes
  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :newest_first, -> { order(created_at: :desc) }

  # Phương thức tùy chỉnh
  def mark_as_read!
    update(is_read: true)
  end

  def self.mark_all_as_read!(user_id)
    where(user_id: user_id, is_read: false).update_all(is_read: true)
  end
end
