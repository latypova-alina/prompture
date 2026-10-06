module Reviews
  class LoadSurvey
    class BuildSurvey
      include Interactor

      delegate :user, :locale, to: :context

      def call
        context.already_reviewed = Review.exists?(user:)
        context.survey = Reviews::SurveyPresenter.new(locale:).as_json
      end
    end
  end
end
