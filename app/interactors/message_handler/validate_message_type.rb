module MessageHandler
  class ValidateMessageType
    include Interactor
    include Memery

    delegate :message_text, :chat_id, :picture_id, :command, to: :context

    VALIDATORS = {
      "prompt_to_image" => ::RecordValidators::CommandRequests::PromptToImage,
      "prompt_to_video" => ::RecordValidators::CommandRequests::PromptToVideo,
      "image_to_video" => ::RecordValidators::CommandRequests::ImageToVideo,
      "image_from_reference" => ::RecordValidators::CommandRequests::ImageFromReference
    }.freeze

    def call
      validator.new(message_text, chat_id, picture_id).validate
    rescue MessageTypeError, CommandRequestForgottenError => e
      context.fail!(error: e.class)
    end

    private

    memoize def validator
      VALIDATORS[command]
    end
  end
end
