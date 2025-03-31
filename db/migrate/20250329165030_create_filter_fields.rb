class CreateFilterFields < ActiveRecord::Migration[7.2]
  def change
    create_table :filter_fields do |t|
      t.string :name
      t.string :field_type
      t.text :options
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end
