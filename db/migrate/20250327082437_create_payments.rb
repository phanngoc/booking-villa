class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.decimal :amount
      t.string :payment_method
      t.integer :status
      t.string :transaction_id

      t.timestamps
    end
  end
end
