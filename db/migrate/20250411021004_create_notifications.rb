class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.boolean :is_read, default: false
      t.string :category
      t.datetime :timestamp

      t.timestamps
    end

    add_index :notifications, :is_read
  end
end
