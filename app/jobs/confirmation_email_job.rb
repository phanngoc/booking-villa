class ConfirmationEmailJob < ApplicationJob
  queue_as :mailers

  def perform(user)
    # Gửi email xác nhận
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token).deliver_now
  end
end 