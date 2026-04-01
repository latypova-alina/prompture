module MediaGenerator
  module MessageHandler
    class ValidateMessageType
      include Interactor
      include Memery

      delegate :message_text, :chat_id, :picture_id, :command, :url, to: :context

      VALIDATORS = {
        "prompt_to_image" => ::RecordValidators::CommandRequests::PromptToImage,
        "prompt_to_video" => ::RecordValidators::CommandRequests::PromptToVideo,
        "image_to_video" => ::RecordValidators::CommandRequests::ImageToVideo,
        "image_from_reference" => ::RecordValidators::CommandRequests::ImageFromReference
      }.freeze

      def call
        validator.new(context: validation_context).validate
      rescue MessageTypeError, CommandRequestForgottenError => e
        context.fail!(error: e.class)
      end

      private

      memoize def validator
        VALIDATORS[command]
      end

      def validation_context
        ValidationContext.new(
          message_text:,
          chat_id:,
          picture_id:,
          command:,
          url:
        )
      end
    end
  end
end
