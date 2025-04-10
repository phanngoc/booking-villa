class AddPaymentMethodRefToPayments < ActiveRecord::Migration[7.2]
  def change
    add_reference :payments, :payment_method, null: true, foreign_key: true
  end
end
