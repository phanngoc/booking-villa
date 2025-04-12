class ChatThread < ApplicationRecord
  # Validations
  validates :status, presence: true

  # Relationships
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :closed, -> { where(status: "closed") }
  scope :unread, -> { where(is_unread: true) }

  # Callbacks
  before_save :update_last_activity

  # Instance methods
  def mark_as_read
    update(is_unread: false)
  end

  def close
    update(status: "closed")
  end

  def reopen
    update(status: "active")
  end

  private

  def update_last_activity
    self.last_activity_at = Time.current
  end
end
