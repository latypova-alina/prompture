module TelegramIntegration
  class ImageInputDispatcher
    HANDLERS = {
      "image_to_video" => MediaGenerator::MessageHandler::ImageMessageHandler::HandleImageMessage,
      "edit_image" => {
        image: MediaGenerator::MessageHandler::EditImageMessageHandler::HandleImageMessage,
        prompt: MediaGenerator::MessageHandler::EditImageMessageHandler::HandlePromptMessage
      }
    }.freeze

    def self.call(...)
      new(...).call
    end

    def initialize(command:, user_message:)
      @command = command
      @user_message = user_message
    end

    def call
      handler.call(command:, user_message:)
    end

    private

    attr_reader :command, :user_message

    def handler
      return HANDLERS[command] unless command == "edit_image"

      image_message? ? HANDLERS["edit_image"][:image] : HANDLERS["edit_image"][:prompt]
    end

    def image_message?
      parsed = MessageParser.new(user_message)

      parsed.picture_id.present? || parsed.image_url.present?
    end
  end
end
