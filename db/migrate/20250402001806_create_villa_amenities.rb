class CreateVillaAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :villa_amenities do |t|
      t.references :villa, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
