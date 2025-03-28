class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :villa, null: false, foreign_key: true
      t.date :check_in
      t.date :check_out
      t.decimal :total_price
      t.integer :status

      t.timestamps
    end
  end
end
