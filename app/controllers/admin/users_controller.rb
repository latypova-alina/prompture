module Admin
  class UsersController < ApplicationController
    layout "admin"

    def index
      @users = User.includes(:balance).order(created_at: :desc)
    end

    def show
      @user = User.includes(:balance).find(params[:id])
      @command_request_count = Admin::CommandRequestsQuery.count(user: @user)
      @button_request_count = Admin::ButtonRequestsQuery.count(user: @user)
    end
  end
end
