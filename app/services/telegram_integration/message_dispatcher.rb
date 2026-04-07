module TelegramIntegration
  class MessageDispatcher
    TOKEN_COMMAND = "activate_token".freeze
    IMAGE_TO_VIDEO_COMMAND = "image_to_video".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(command:, chat_id:, user_message:, name:, locale:)
      @command = command
      @chat_id = chat_id
      @user_message = user_message
      @name = name
      @locale = locale
    end

    def call
      raise handled_command.error if handled_command.failure?
    end

    private

    attr_reader :command, :chat_id, :user_message, :name, :locale

    def handled_command
      case command
      when TOKEN_COMMAND
        TokenHandler::HandleToken.call(chat_id:, token_code: user_message["text"], name:, locale:)
      when IMAGE_TO_VIDEO_COMMAND
        MediaGenerator::MessageHandler::ImageMessageHandler::HandleImageMessage.call(command:, user_message:)
      else
        MediaGenerator::MessageHandler::HandleMessage.call(command:, user_message:)
      end
    end
  end
end
