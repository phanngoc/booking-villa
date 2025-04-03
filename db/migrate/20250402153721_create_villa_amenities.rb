class CreateVillaAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :villa_amenities do |t|
      t.references :villa, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end

    # Thêm composite index để tối ưu cho việc tìm kiếm
    add_index :villa_amenities, [ :villa_id, :amenity_id ], unique: true
    add_index :villa_amenities, :value # Index cho việc search theo giá trị
  end
end
