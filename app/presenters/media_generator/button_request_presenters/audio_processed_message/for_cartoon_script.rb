module MediaGenerator
  module ButtonRequestPresenters
    module AudioProcessedMessage
      class ForCartoonScript < ::MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter
        def initialize(request:, **kwargs)
          super(**kwargs)
          @request = request
        end

        def inline_keyboard
          Buttons::ForCartoonScriptAudio.build(locale:)
        end

        private

        attr_reader :request
      end
    end
  end
end
