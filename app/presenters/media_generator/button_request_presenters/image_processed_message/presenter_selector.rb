module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class PresenterSelector
        PRESENTERS = {
          "CommandPromptToImageRequest" => ForPromptToImage,
          "CommandPromptToVideoRequest" => ForPromptToVideo
        }.freeze

        def initialize(image_url, command_request_classname, locale, balance)
          @image_url = image_url
          @command_request_classname = command_request_classname
          @locale = locale
          @balance = balance
        end

        attr_reader :image_url, :command_request_classname, :locale, :balance

        def presenter
          PRESENTERS[command_request_classname].new(message: image_url, locale:, balance:)
        end
      end
    end
  end
end
