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

        delegate :image_url, :command_request_classname, :command_request_category, :locale, :balance,
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
          if CommandEditImageRequest.cartoon_script_edit_image?(
            classname: command_request_classname,
            category: command_request_category
          )
            ForCartoonScriptEditImage
          else
            PRESENTERS.fetch(command_request_classname)
          end
        end
      end
    end
  end
end
