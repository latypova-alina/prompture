module MediaGenerator
  module ButtonRequestPresenters
    module ForBloomy
      class GenerateVideosCtaPresenter < ::BasePresenter
        include MessageInterface

        def initialize(pairs_count:, **kwargs)
          super(**kwargs)
          @pairs_count = pairs_count
        end

        def formatted_text
          I18n.t("telegram_webhooks.message.bloomy_complex.all_images_generated", locale:)
        end

        def inline_keyboard
          Buttons::ForBloomy::GenerateComplexVideos.build(pairs_count:, locale:)
        end

        private

        attr_reader :pairs_count
      end
    end
  end
end
