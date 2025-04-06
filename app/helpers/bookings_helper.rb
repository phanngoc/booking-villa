module BookingsHelper
  # Trả về class bootstrap tương ứng với trạng thái đặt phòng
  def booking_status_color(status)
    case status
    when 'pending'
      'warning'
    when 'confirmed'
      'primary'
    when 'completed'
      'success'
    when 'cancelled'
      'danger'
    else
      'secondary'
    end
  end

  # Trả về class bootstrap tương ứng với trạng thái thanh toán
  def payment_status_color(status)
    case status
    when 'pending'
      'warning'
    when 'paid'
      'success'
    when 'refunded'
      'info'
    when 'failed'
      'danger'
    else
      'secondary'
    end
  end
end 