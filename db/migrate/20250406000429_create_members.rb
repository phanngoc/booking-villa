class CreateMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :role

      t.timestamps
    end
    add_index :members, :email, unique: true
  end
end
