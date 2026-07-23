module ScriptGenerator
  module ForBloomy
    module GenerateVideosCta
      class Generator
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(button_request:)
          @button_request = button_request
        end

        def call
          return unless ready_for_cta?

          TelegramIntegration::SendMessageWithButtons.call(
            reply_data: presenter.reply_data,
            request: command_request
          )
        end

        private

        attr_reader :button_request

        delegate :command_request, to: :button_request

        delegate :ready_for_cta?, :presenter, to: :facade

        memoize def facade
          Facade.new(button_request:)
        end
      end
    end
  end
end
