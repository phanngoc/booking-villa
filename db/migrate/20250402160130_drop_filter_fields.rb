class DropFilterFields < ActiveRecord::Migration[7.2]
  def up
    drop_table :filter_fields
    drop_table :filter_options, if_exists: true
    drop_table :filter_groups, if_exists: true
    drop_table :villa_filter_values, if_exists: true
  end

  def down
    create_table :filter_fields do |t|
      t.string :name
      t.string :field_type
      t.string :key_query
      t.string :column_name
      t.text :options
      t.integer :position
      t.boolean :active, default: true

      t.timestamps
    end

    create_table :filter_options do |t|
      t.references :filter_field, null: false, foreign_key: true
      t.string :name
      t.string :value
      t.integer :position

      t.timestamps
    end

    create_table :filter_groups do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    create_table :villa_filter_values do |t|
      t.references :villa, null: false, foreign_key: true
      t.references :filter_field, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
