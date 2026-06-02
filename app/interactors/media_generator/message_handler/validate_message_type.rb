module MediaGenerator
  module MessageHandler
    class ValidateMessageType
      include Interactor
      include Memery

      delegate :message_text, :picture_id, :command, to: :context

      VALIDATORS = {
        "prompt_to_image" => ::RecordValidators::CommandRequests::PromptToImage,
        "prompt_to_audio" => ::RecordValidators::CommandRequests::PromptToAudio,
        "prompt_to_video" => ::RecordValidators::CommandRequests::PromptToVideo
      }.freeze

      def call
        validator.validate
      rescue MessageTypeError, ImageNotReadyError => e
        context.fail!(error: e.class)
      end

      private

      memoize def validator
        return edit_image_validator if command == "edit_image"

        VALIDATORS.fetch(command).new(message_text:, picture_id:)
      end

      def edit_image_validator
        ::RecordValidators::CommandRequests::EditImage.new(
          command_request: context.command_request,
          message_text:,
          picture_id:
        )
      end
    end
  end
end
