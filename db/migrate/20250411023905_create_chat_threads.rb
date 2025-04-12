class CreateChatThreads < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_threads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: "active"
      t.string :title
      t.boolean :is_unread, default: true
      t.datetime :last_activity_at

      t.timestamps
    end

    add_index :chat_threads, :status
  end
end
