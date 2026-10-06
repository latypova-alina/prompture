module Admin
  class UsersController < ApplicationController
    layout "admin"

    def index
      @sort = Admin::SortParams.call(params, keys: Admin::UsersQuery::SORT_KEYS)
      @users = Admin::UsersQuery.call(sort: @sort)
    end

    def show
      @user = User.includes(:balance, :review).find(params[:id])
      @command_request_count = Admin::CommandRequestsQuery.count(user: @user)
      @button_request_count = Admin::ButtonRequestsQuery.count(user: @user)
    end
  end
end
