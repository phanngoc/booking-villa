class AddSolanaInfoToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :sol_amount, :decimal
    add_column :payments, :payment_address, :string
  end
end
