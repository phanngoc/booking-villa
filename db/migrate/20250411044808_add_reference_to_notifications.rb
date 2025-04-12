class AddReferenceToNotifications < ActiveRecord::Migration[7.2]
  def change
    add_reference :notifications, :reference, polymorphic: true, null: true
  end
end
