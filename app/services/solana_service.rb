require "httparty"
require "net/http"
require "uri"
require "json"

class SolanaService
  SOLANA_RPC_URL = ENV["SOLANA_RPC_URL"] || "https://api.mainnet-beta.solana.com"
  SOLANA_EXPLORER_URL = "https://explorer.solana.com"

  class << self
    def get_sol_price_in_vnd
      # Trong môi trường thực tế, bạn sẽ sử dụng API từ sàn giao dịch hoặc dịch vụ như CoinGecko
      begin
        response = HTTParty.get("https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=vnd")
        if response.success?
          data = JSON.parse(response.body)
          return data["solana"]["vnd"]
        end
      rescue => e
        Rails.logger.error "Error fetching SOL price: #{e.message}"
      end

      # Giá mẫu nếu API không hoạt động
      500000 # 1 SOL = 500,000 VND
    end

    def verify_transaction(signature, recipient_address, expected_sol_amount)
      return false if signature.blank?

      # Chuẩn bị request
      body = {
        jsonrpc: "2.0",
        id: 1,
        method: "getTransaction",
        params: [
          signature,
          { encoding: "jsonParsed" }
        ]
      }

      # Gửi request và xử lý response
      begin
        response = HTTParty.post(
          SOLANA_RPC_URL,
          body: body.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        # Kiểm tra lỗi
        unless response.success?
          Rails.logger.error "Solana RPC HTTP error: #{response.code}"
          return false
        end

        data = JSON.parse(response.body)
        if data["error"]
          Rails.logger.error "Solana RPC error: #{data['error']['message']}"
          return false
        end

        # Kiểm tra kết quả
        result = data["result"]
        return false unless result

        # Xác minh trạng thái giao dịch
        return false unless result["meta"] && result["meta"]["err"].nil?

        # Lấy thông tin về người nhận và số lượng SOL
        transaction_info = result["transaction"]["message"]
        instructions = transaction_info["instructions"]

        # Tìm instruction chuyển SOL
        instructions.each do |instruction|
          # Kiểm tra nếu là instruction chuyển tiền
          if instruction["program"] == "system" && instruction["parsed"]["type"] == "transfer"
            transfer_info = instruction["parsed"]["info"]

            # Kiểm tra người nhận
            if transfer_info["destination"] == recipient_address
              # Kiểm tra số lượng (chuyển từ lamports sang SOL)
              amount_sol = transfer_info["lamports"].to_f / 1_000_000_000

              # So sánh với số tiền mong đợi (cho phép sai số nhỏ)
              if (amount_sol - expected_sol_amount).abs <= 0.000001
                return true
              end
            end
          end
        end

        false
      rescue => e
        Rails.logger.error "Error verifying Solana transaction: #{e.message}"
        false
      end
    end

    def get_wallet_balance(address)
      # Chuẩn bị request
      body = {
        jsonrpc: "2.0",
        id: 1,
        method: "getBalance",
        params: [ address ]
      }

      # Gửi request và xử lý response
      begin
        response = HTTParty.post(
          SOLANA_RPC_URL,
          body: body.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        # Kiểm tra lỗi
        unless response.success?
          Rails.logger.error "Solana RPC HTTP error: #{response.code}"
          return nil
        end

        data = JSON.parse(response.body)
        if data["error"]
          Rails.logger.error "Solana RPC error: #{data['error']['message']}"
          return nil
        end

        # Chuyển đổi từ lamports sang SOL
        data["result"]["value"].to_f / 1_000_000_000
      rescue => e
        Rails.logger.error "Error getting Solana wallet balance: #{e.message}"
        nil
      end
    end
  end
end
