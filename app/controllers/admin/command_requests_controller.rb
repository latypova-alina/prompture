module Admin
  class CommandRequestsController < ApplicationController
    layout "admin"

    def index
      @user = User.find(params[:user_id]) if params[:user_id]
      @result = Admin::CommandRequestsQuery.call(user: @user, filters:, page: params[:page] || 1)
    end

    private

    def filters
      Admin::CommandRequestsQuery::Filters.new(
        type: params[:type],
        user_search: params[:user],
        has_button_requests: params[:has_button_requests],
        date_from: params[:date_from],
        date_to: params[:date_to]
      )
    end
  end
end
