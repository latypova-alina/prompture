module ButtonRequestPresenters
  module ImageProcessedMessage
    class PresenterSelector
      PRESENTERS = {
        "CommandPromptToImageRequest" => ForPromptToImage,
        "CommandPromptToVideoRequest" => ForPromptToVideo
      }.freeze

      def initialize(image_url, command_request_classname)
        @image_url = image_url
        @command_request_classname = command_request_classname
      end

      attr_reader :image_url, :command_request_classname

      def presenter
        PRESENTERS[command_request_classname].new(message: image_url)
      end
    end
  end
end
