class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking
  before_action :set_payment
  before_action :load_payment_methods, only: [ :choose_payment_method ]

  def show
  end

  def choose_payment_method
  end

  def update
    selected_payment_method = PaymentMethod.find_by(id: payment_params[:payment_method_id])

    if params[:confirm_cash].present?
      # Xử lý xác nhận thanh toán tiền mặt
      @payment.update(status: :completed)
      @booking.confirmed!
      redirect_to booking_payment_path(@booking, @payment), notice: "Đã xác nhận thanh toán tiền mặt khi nhận phòng"
    elsif params[:bank_transfer_confirmed].present? && params[:transaction_id].present?
      # Xử lý xác nhận thanh toán chuyển khoản ngân hàng
      @payment.update(
        transaction_id: params[:transaction_id],
        status: :pending # Đợi admin xác nhận
      )
      redirect_to booking_payment_path(@booking, @payment), notice: "Đã ghi nhận thông tin thanh toán của bạn. Chúng tôi sẽ xác nhận trong thời gian sớm nhất!"
    elsif @payment.update(payment_params)
      if selected_payment_method&.name == "sol_wallet"
        redirect_to sol_payment_booking_payment_path(@booking, @payment)
      else
        redirect_to booking_payment_path(@booking, @payment), notice: "Phương thức thanh toán đã được cập nhật"
      end
    else
      render :choose_payment_method, status: :unprocessable_entity
    end
  end

  def sol_payment
    # Tìm phương thức thanh toán Solana
    sol_payment_method = PaymentMethod.find_by(name: "sol_wallet")

    # Đảm bảo payment method được đặt thành sol_wallet
    @payment.update(payment_method_id: sol_payment_method.id) unless @payment.sol_wallet?

    # Tính toán số lượng SOL và lấy địa chỉ ví
    @sol_amount = calculate_sol_amount(@payment.amount)
    @payment_address = generate_payment_address

    # Lưu thông tin vào payment để dễ xác minh sau này
    @payment.update(
      sol_amount: @sol_amount,
      payment_address: @payment_address
    )
  end

  def bank_transfer
    # Tìm phương thức thanh toán bank transfer
    bank_payment_method = PaymentMethod.find_by(name: "bank_transfer")

    # Đảm bảo payment method được đặt thành bank_transfer
    @payment.update(payment_method_id: bank_payment_method.id) unless @payment.bank_transfer?

    # Thông tin ngân hàng để hiển thị
    @bank_info = {
      bank_name: "Ngân hàng TMCP Ngoại thương Việt Nam (Vietcombank)",
      account_number: "1234567890",
      account_name: "CÔNG TY TNHH VILLA BOOKING",
      branch: "Hồ Chí Minh",
      amount: @payment.amount,
      description: "Thanh toan dat phong #{@booking.id}"
    }
  end

  def verify_sol_payment
    # Lấy thông tin từ form
    transaction_signature = params[:signature]

    # Gọi service để xác minh giao dịch
    if SolanaService.verify_transaction(transaction_signature, @payment.payment_address, @payment.sol_amount)
      @payment.transaction_id = transaction_signature
      @payment.completed!
      redirect_to booking_path(@booking), notice: "Thanh toán thành công!"
    else
      @payment.failed!
      redirect_to booking_path(@booking), alert: "Thanh toán thất bại. Vui lòng thử lại."
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:booking_id])
  end

  def set_payment
    @payment = @booking.payment
  end

  def load_payment_methods
    @payment_methods = PaymentMethod.active
  end

  def payment_params
    params.require(:payment).permit(:payment_method_id)
  end

  def calculate_sol_amount(vnd_amount)
    # Sử dụng service để lấy tỷ giá SOL/VND
    sol_to_vnd_rate = Rails.cache.fetch("sol_to_vnd_rate", expires_in: 5.minutes) do
      SolanaService.get_sol_price_in_vnd
    end

    (vnd_amount.to_f / sol_to_vnd_rate).round(6)
  end

  def generate_payment_address
    # Trong thực tế, bạn sẽ lấy từ cấu hình hoặc tạo địa chỉ mới cho mỗi giao dịch
    ENV["SOLANA_WALLET_ADDRESS"] || "FZLEGPuQhEqn8XdKiKTQGtBZ1VDqcEXmkstYvcBcgjnz"
  end
end
