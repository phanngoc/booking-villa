class AddActiveToVillaAmenities < ActiveRecord::Migration[7.2]
  def change
    add_column :villa_amenities, :active, :boolean, default: true, null: false
  end
end
