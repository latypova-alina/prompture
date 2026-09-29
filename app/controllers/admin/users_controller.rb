module Admin
  class UsersController < ApplicationController
    def index
      @users = User.includes(:balance).order(created_at: :desc)
    end

    def show
      @user = User.includes(:balance).find(params[:id])
      @entries = Admin::UserGenerationHistory.call(user: @user)
    end
  end
end
