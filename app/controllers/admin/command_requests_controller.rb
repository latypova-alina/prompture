module Admin
  class CommandRequestsController < ApplicationController
    include Admin::NotFoundHandling

    layout "admin"

    def index
      @user = User.find(params[:user_id]) if params[:user_id]
      @result = Admin::CommandRequestsQuery.call(user: @user, filters:, page: params[:page] || 1)
      @button_requests = Admin::CommandButtonRequestsLoader.call(@result.records)
    end

    def show
      @command_request = Admin::RequestLookup.call(types: Admin::CommandRequestsQuery::TYPES, slug: params[:type],
                                                   id: params[:id])
      @inputs = Admin::CommandInputs.call(@command_request)
      @button_requests = Admin::CommandButtonRequestsLoader.call([@command_request]).values.flatten
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
