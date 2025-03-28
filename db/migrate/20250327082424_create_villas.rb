class CreateVillas < ActiveRecord::Migration[7.2]
  def change
    create_table :villas do |t|
      t.string :name
      t.text :address
      t.decimal :price
      t.text :amenities
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
