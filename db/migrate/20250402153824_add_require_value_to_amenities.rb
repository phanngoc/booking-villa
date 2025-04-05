class AddRequireValueToAmenities < ActiveRecord::Migration[7.2]
  def change
    add_column :amenities, :require_value, :boolean, default: false
  end
end
