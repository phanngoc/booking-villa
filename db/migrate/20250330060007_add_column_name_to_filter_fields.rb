class AddColumnNameToFilterFields < ActiveRecord::Migration[7.1]
  def up
    add_column :filter_fields, :column_name, :string, default: ''
    
    # Set default values for existing records
    execute <<-SQL
      UPDATE filter_fields 
      SET column_name = key_query 
      WHERE column_name = ''
    SQL
    
    # Add null constraint after setting values
    change_column_null :filter_fields, :column_name, false
    add_index :filter_fields, :column_name
  end

  def down
    remove_index :filter_fields, :column_name
    remove_column :filter_fields, :column_name
  end
end
