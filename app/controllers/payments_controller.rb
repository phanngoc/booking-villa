class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking
  before_action :set_payment

  def show
  end

  def choose_payment_method
  end

  def update
    if @payment.update(payment_params)
      if payment_params[:payment_method] == "sol_wallet"
        redirect_to sol_payment_booking_payment_path(@booking, @payment)
      else
        redirect_to booking_payment_path(@booking, @payment), notice: "Ph\u01B0\u01A1ng th\u1EE9c thanh to\u00E1n \u0111\u00E3 \u0111\u01B0\u1EE3c c\u1EADp nh\u1EADt"
      end
    else
      render :choose_payment_method, status: :unprocessable_entity
    end
  end

  def sol_payment
    # Tính toán số lượng SOL và lấy địa chỉ ví
    @sol_amount = calculate_sol_amount(@payment.amount)
    @payment_address = generate_payment_address

    # Lưu thông tin vào payment để dễ xác minh sau này
    @payment.update(
      sol_amount: @sol_amount,
      payment_address: @payment_address
    )
  end

  def verify_sol_payment
    # Lấy thông tin từ form
    transaction_signature = params[:signature]

    # Gọi service để xác minh giao dịch
    if SolanaService.verify_transaction(transaction_signature, @payment.payment_address, @payment.sol_amount)
      @payment.transaction_id = transaction_signature
      @payment.completed!
      redirect_to booking_path(@booking), notice: "Thanh to\u00E1n th\u00E0nh c\u00F4ng!"
    else
      @payment.failed!
      redirect_to booking_path(@booking), alert: "Thanh to\u00E1n th\u1EA5t b\u1EA1i. Vui l\u00F2ng th\u1EED l\u1EA1i."
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:booking_id])
  end

  def set_payment
    @payment = @booking.payment
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
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
