module MediaGenerator
  module MessageHandler
    module ImageToVideoMessageHandler
      class ValidatePromptMessageType
        include Interactor

        delegate :message_text, :picture_id, :command_request, to: :context

        def call
          validator.validate
        rescue MessageTypeError, ImageNotReadyError => e
          context.fail!(error: e.class)
        end

        private

        def validator
          ::RecordValidators::CommandRequests::ImageToVideo::Prompt.new(
            command_request:,
            message_text:,
            picture_id:
          )
        end
      end
    end
  end
end
