module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class PresenterSelector
        PRESENTERS = {
          "CommandPromptToImageRequest" => ForPromptToImage,
          "CommandPromptToVideoRequest" => ForPromptToVideo
        }.freeze

        def initialize(image_url, command_request_classname, locale)
          @image_url = image_url
          @command_request_classname = command_request_classname
          @locale = locale
        end

        attr_reader :image_url, :command_request_classname, :locale

        def presenter
          PRESENTERS[command_request_classname].new(message: image_url, locale:)
        end
      end
    end
  end
end
