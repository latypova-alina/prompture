module ScriptGenerator
  module ForBloomy
    module GenerateVideosCta
      class Facade
        include Memery

        def initialize(button_request:)
          @button_request = button_request
        end

        delegate :ready_for_cta?, to: :ready_for_cta_validator
        delegate :pairs_count, to: :pairs_count_calculator
        delegate :presenter, to: :presenter_selector

        private

        attr_reader :button_request

        delegate :command_request, to: :button_request
        delegate :user, to: :command_request
        delegate :locale, to: :user
        delegate :scenes, to: :chained_scenes

        memoize def chained_scenes
          ChainedScenes::Facade.new(button_request:)
        end

        memoize def ready_for_cta_validator
          ReadyForCtaValidator.new(chained_scenes:)
        end

        memoize def pairs_count_calculator
          PairsCount.new(scenes:)
        end

        memoize def presenter_selector
          PresenterSelector.new(pairs_count:, locale:)
        end
      end
    end
  end
end
