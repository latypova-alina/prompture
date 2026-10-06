module MiniApp
  class ReviewsController < ApplicationController
    layout false

    skip_before_action :verify_authenticity_token, only: %i[survey create]

    def show; end

    def survey
      result = Reviews::LoadSurvey.call(init_data: params[:init_data])
      return render_error(result) if result.failure?

      render json: { already_reviewed: result.already_reviewed, survey: result.survey }
    end

    def create
      result = Reviews::Submit.call(init_data: params[:init_data], answers: answers_param)
      return render_error(result) if result.failure?

      render json: { message: I18n.t("reviews.mini_app.success", locale: result.locale) }, status: :created
    end

    private

    # Shape is checked by Reviews::AnswersValidator, which also drops anything unexpected.
    def answers_param
      params.fetch(:answers, {}).to_unsafe_h
    end

    def render_error(result)
      response = Reviews::ErrorResponse.new(result)

      render json: response.body, status: response.status
    end
  end
end
