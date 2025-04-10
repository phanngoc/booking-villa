class AddAttributesToPaymentModel < ActiveRecord::Migration[7.2]
  def change
    # Thêm các cột mới nếu cần

    # Xóa attribute ảo payment_method nếu tồn tại
    # Không có thao tác trực tiếp từ migration, cần sửa model

    # Đảm bảo rằng payment_method_id có thể là null
    change_column_null :payments, :payment_method_id, true
  end
end
