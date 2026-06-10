module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class PresenterSelector
        PRESENTERS = {
          "CommandPromptToImageRequest" => ForPromptToImage,
          "CommandPromptToVideoRequest" => ForPromptToVideo,
          "CommandEditImageRequest" => ForEditImage
        }.freeze

        def initialize(context:)
          @context = context
        end

        attr_reader :context

        delegate :image_url, :command_request, :command_request_classname, :locale, :balance,
                 :processor_name, :processor, to: :context

        def presenter
          presenter_class.new(
            message: image_url,
            locale:,
            balance:,
            processor_name:,
            processor:
          )
        end

        private

        def presenter_class
          if command_request.cartoon_script?
            ForCartoonScriptEditImage
          else
            PRESENTERS.fetch(command_request_classname)
          end
        end
      end
    end
  end
end
