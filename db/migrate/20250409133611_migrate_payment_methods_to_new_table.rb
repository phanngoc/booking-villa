class MigratePaymentMethodsToNewTable < ActiveRecord::Migration[7.2]
  def up
    # Thêm unique index cho cột name
    add_index :payment_methods, :name, unique: true, if_not_exists: true

    # Đảm bảo đã có dữ liệu payment_methods
    payment_methods_data = [
      [ 'credit_card', 'Thẻ tín dụng / Thẻ ghi nợ' ],
      [ 'bank_transfer', 'Chuyển khoản ngân hàng' ],
      [ 'cash', 'Tiền mặt' ],
      [ 'sol_wallet', 'Solana (SOL)' ]
    ]

    payment_methods_data.each do |name, description|
      # Kiểm tra xem bản ghi đã tồn tại chưa
      next if PaymentMethod.where(name: name).exists?

      # Nếu chưa tồn tại thì tạo mới
      PaymentMethod.create!(
        name: name,
        description: description,
        active: true
      )
    end

    # Di chuyển dữ liệu từ cột payment_method sang payment_method_id
    Payment.find_each do |payment|
      if payment.respond_to?(:payment_method) && payment.read_attribute(:payment_method).present?
        method_name = case payment.read_attribute(:payment_method)
        when 0 then 'credit_card'
        when 1 then 'bank_transfer'
        when 2 then 'cash'
        when 3 then 'sol_wallet'
        else nil
        end

        if method_name
          payment_method = PaymentMethod.find_by(name: method_name)
          payment.update_columns(payment_method_id: payment_method.id) if payment_method
        end
      end
    end
  end

  def down
    # Xóa unique index khi rollback
    remove_index :payment_methods, :name, if_exists: true

    # Nếu cần rollback, chúng ta không thể khôi phục lại dữ liệu đã mất
    say "Cannot rollback this migration", true
  end
end
