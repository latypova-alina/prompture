module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class PresenterSelector
        PRESENTERS = {
          "CommandPromptToImageRequest" => ForPromptToImage,
          "CommandPromptToVideoRequest" => ForPromptToVideo
        }.freeze

        def initialize(context:)
          @context = context
        end

        attr_reader :context

        delegate :image_url, :command_request_classname, :locale, :balance, :processor_name, :processor, to: :context

        def presenter
          PRESENTERS[command_request_classname].new(
            message: image_url,
            locale:,
            balance:,
            processor_name:,
            processor:
          )
        end
      end
    end
  end
end
