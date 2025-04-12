class Message < ApplicationRecord
  # Validations
  validates :content, presence: true
  validates :sender, presence: true

  # Relationships
  belongs_to :chat_thread, touch: true
  has_one :notification, dependent: :destroy

  # Callbacks
  after_create :update_thread_status

  # Scopes
  scope :by_user, -> { where(sender: "user") }
  scope :by_admin, -> { where(sender: "admin") }
  scope :unread, -> { where(is_read: false) }

  # Constants
  SENDER_TYPES = [ "user", "admin" ]

  # Instance methods
  def by_user?
    sender == "user"
  end

  def by_admin?
    sender == "admin"
  end

  def mark_as_read
    update(is_read: true)
  end

  private

  def update_thread_status
    chat_thread.update(
      is_unread: true,
      last_activity_at: Time.current
    )
  end

  # Notification creation moved to NotificationService
end
