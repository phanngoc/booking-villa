class CreatePaymentMethods < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.boolean :active

      t.timestamps
    end
  end
end
