module MediaGenerator
  module ButtonRequestPresenters
    module VideoProcessedMessage
      class ForCartoonScript < ::MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter
        def inline_keyboard
          Buttons::ForCartoonScriptVideo.build(locale:, processor:)
        end
      end
    end
  end
end
