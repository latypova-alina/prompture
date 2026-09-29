module Admin
  class UsersController < ApplicationController
    layout "admin"

    def index
      @users = User.includes(:balance).order(created_at: :desc)
    end

    def show
      @user = User.includes(:balance).find(params[:id])
      @command_request_count = Admin::CommandRequestsQuery.call(user: @user).total_count
      @button_request_count = Admin::ButtonRequestsQuery.call(user: @user).total_count
    end
  end
end
