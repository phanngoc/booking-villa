class AddDetailsToVillas < ActiveRecord::Migration[7.2]
  def change
    add_column :villas, :rooms, :integer
    add_column :villas, :bathrooms, :integer
    add_column :villas, :max_guests, :integer
    add_column :villas, :images, :string
  end
end
