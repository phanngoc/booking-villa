class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat_thread, null: false, foreign_key: true
      t.text :content, null: false
      t.string :sender, null: false
      t.boolean :is_read, default: false

      t.timestamps
    end

    add_index :messages, :sender
  end
end
