module Admin
  class ButtonRequestsController < ApplicationController
    layout "admin"

    def index
      @user = User.find(params[:user_id])
      @result = Admin::ButtonRequestsQuery.call(
        user: @user,
        type: params[:type],
        date_from: params[:date_from],
        date_to: params[:date_to],
        page: params[:page] || 1
      )
    end
  end
end
