module Admin
  class ButtonRequestsController < ApplicationController
    layout "admin"

    def index
      @user = User.find(params[:user_id]) if params[:user_id]
      @result = Admin::ButtonRequestsQuery.call(user: @user, filters:, page: params[:page] || 1)
    end

    private

    def filters
      Admin::ButtonRequestsQuery::Filters.new(
        type: params[:type],
        status: params[:status],
        processor: params[:processor],
        command_type: params[:command_type],
        user_search: params[:user],
        date_from: params[:date_from],
        date_to: params[:date_to]
      )
    end
  end
end
