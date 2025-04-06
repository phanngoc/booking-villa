class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin

  def index
    @users = User.all.order(created_at: :desc)

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil

      if start_date && end_date
        @users = @users.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      end
    end

    @users = @users.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end
end
