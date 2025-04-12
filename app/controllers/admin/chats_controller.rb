module Admin
  class ChatsController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!
    before_action :set_chat_thread, only: [ :show ]

    # GET /admin/chats
    # Hiển thị bảng điều khiển chat cho admin
    def index
      @chat_threads = ChatThread.order(last_activity_at: :desc)
      @active_threads = @chat_threads.active
      @closed_threads = @chat_threads.closed
    end

    # GET /admin/chats/:id
    # Xem và trả lời một cuộc trò chuyện cụ thể
    def show
      return redirect_to admin_chats_path if params[:id] == "chat_console"
      @messages = @chat_thread.messages.order(created_at: :asc)

      # Đánh dấu tất cả tin nhắn của user là đã đọc khi admin xem
      @chat_thread.messages.by_user.unread.update_all(is_read: true)
      @chat_thread.update(is_unread: false)
      
      # Lấy thông tin về admin và thread để truyền vào view
      @admin_id = current_admin.id
      @thread_id = @chat_thread.id
      
      # Nếu là AJAX request, chỉ trả về phần show partial
      respond_to do |format|
        format.html
        format.json { render json: { messages: @messages, thread: @chat_thread } }
        format.js
      end
    end

    # GET /admin/chats/chat_console
    # Hiển thị bảng điều khiển chat realtime
    def chat_console
      # View được hiển thị dựa trên tệp chat_console.html.erb
    end

    # PATCH /admin/chats/:id/close
    # Đóng một cuộc trò chuyện
    def close
      @chat_thread = ChatThread.find(params[:id])
      @chat_thread.close

      # Thông báo về việc đóng cuộc trò chuyện qua ActionCable
      ActionCable.server.broadcast(
        "chat_thread_#{@chat_thread.id}",
        {
          action: "thread_closed",
          chat_thread_id: @chat_thread.id
        }
      )

      respond_to do |format|
        format.html { redirect_to admin_chats_path, notice: "Cu\u1ED9c tr\u00F2 chuy\u1EC7n \u0111\u00E3 \u0111\u00F3ng." }
        format.json { head :no_content }
      end
    end

    # PATCH /admin/chats/:id/reopen
    # Mở lại một cuộc trò chuyện đã đóng
    def reopen
      @chat_thread = ChatThread.find(params[:id])
      @chat_thread.reopen

      # Thông báo về việc mở lại cuộc trò chuyện qua ActionCable
      ActionCable.server.broadcast(
        "chat_thread_#{@chat_thread.id}",
        {
          action: "thread_reopened",
          chat_thread_id: @chat_thread.id
        }
      )

      respond_to do |format|
        format.html { redirect_to admin_chat_path(@chat_thread), notice: "Cu\u1ED9c tr\u00F2 chuy\u1EC7n \u0111\u00E3 \u0111\u01B0\u1EE3c m\u1EDF l\u1EA1i." }
        format.json { head :no_content }
      end
    end

    private

    def set_chat_thread
      return if params[:id] == "chat_console"
      @chat_thread = ChatThread.find(params[:id])
    end
  end
end
