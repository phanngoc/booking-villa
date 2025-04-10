class RemovePaymentMethodColumnFromPayments < ActiveRecord::Migration[7.2]
  def change
    remove_column :payments, :payment_method, :string
  end
end
