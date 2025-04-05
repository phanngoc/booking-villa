class AddKeyQueryToFilterFields < ActiveRecord::Migration[7.2]
  def change
    add_column :filter_fields, :key_query, :string
    add_index :filter_fields, :key_query, unique: true
  end
end
