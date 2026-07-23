module ScriptGenerator
  module ForBloomy
    module GenerateVideosCta
      class PresenterSelector
        def initialize(pairs_count:, locale:)
          @pairs_count = pairs_count
          @locale = locale
        end

        def presenter
          MediaGenerator::ButtonRequestPresenters::ForBloomy::GenerateVideosCtaPresenter.new(
            pairs_count:,
            locale:
          )
        end

        private

        attr_reader :pairs_count, :locale
      end
    end
  end
end
