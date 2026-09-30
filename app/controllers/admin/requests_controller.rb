module Admin
  class RequestsController < ApplicationController
    layout "admin"

    def index
      @result = Admin::RequestsQuery.call(filters:, page: params[:page] || 1)
    end

    private

    def filters
      Admin::RequestsQuery::Filters.new(
        user_search: params[:user],
        date_from: params[:date_from],
        date_to: params[:date_to]
      )
    end
  end
end
