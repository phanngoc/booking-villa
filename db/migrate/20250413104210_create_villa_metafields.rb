class CreateVillaMetafields < ActiveRecord::Migration[7.2]
  def change
    create_table :villa_metafields do |t|
      t.references :villa, null: false, foreign_key: true
      t.string :namespace, null: false
      t.string :key, null: false
      t.string :value_type, default: 'string'
      t.text :value
      t.boolean :visible_on_frontend, default: true
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :villa_metafields, [:villa_id, :namespace, :key], unique: true
    add_index :villa_metafields, [:namespace, :key]
  end
end
