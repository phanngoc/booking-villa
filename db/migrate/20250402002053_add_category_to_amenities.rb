class AddCategoryToAmenities < ActiveRecord::Migration[7.2]
  def change
    add_column :amenities, :category, :string
  end
end
