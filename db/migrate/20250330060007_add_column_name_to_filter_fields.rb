class AddColumnNameToFilterFields < ActiveRecord::Migration[7.1]
  def up
    add_column :filter_fields, :column_name, :string
    
    # Set default values
    FilterField.find_each do |filter|
      filter.update_column(:column_name, filter.key_query)
    end
    
    # Add null constraint after setting values
    change_column_null :filter_fields, :column_name, false
    add_index :filter_fields, :column_name
  end

  def down
    remove_index :filter_fields, :column_name
    remove_column :filter_fields, :column_name
  end
end
