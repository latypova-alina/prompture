module MediaGenerator
  module MessageHandler
    class ValidateMessageType
      include Interactor
      include Memery

      delegate :message_text, :picture_id, :command, to: :context

      VALIDATORS = {
        "prompt_to_image" => ::RecordValidators::CommandRequests::PromptToImage,
        "prompt_to_video" => ::RecordValidators::CommandRequests::PromptToVideo,
        "image_from_reference" => ::RecordValidators::CommandRequests::ImageFromReference
      }.freeze

      def call
        validator.validate
      rescue MessageTypeError => e
        context.fail!(error: e.class)
      end

      private

      memoize def validator
        VALIDATORS[command].new(message_text:, picture_id:)
      end
    end
  end
end
