module TelegramIntegration
  class ImageInputDispatcher
    HANDLERS = {
      "image_to_video" => {
        image: MediaGenerator::MessageHandler::ImageMessageHandler::HandleImageMessage,
        prompt: MediaGenerator::MessageHandler::ImageToVideoMessageHandler::HandlePromptMessage
      },
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
      HANDLERS.fetch(command).fetch(message_kind)
    end

    def message_kind
      image_message? ? :image : :prompt
    end

    def image_message?
      parsed = MessageParser.new(user_message)

      parsed.picture_id.present? || parsed.image_url.present?
    end
  end
end
