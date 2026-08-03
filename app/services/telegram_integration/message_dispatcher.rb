module TelegramIntegration
  class MessageDispatcher
    include Memery

    TOKEN_COMMAND = "activate_token".freeze
    IMAGE_INPUT_COMMANDS = %w[image_to_video first_last_frame_to_video edit_image].freeze

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
      raise result.error if result.failure?
    end

    private

    attr_reader :command, :chat_id, :user_message, :name, :locale

    delegate :pack_key, :telegram_payment_charge_id, :stars_amount, to: :successful_payment

    def result
      return handle_successful_payment if successful_payment.present?

      case command
      when TOKEN_COMMAND
        TokenHandler::HandleToken.call(chat_id:, token_code: user_message["text"], name:, locale:)
      when *IMAGE_INPUT_COMMANDS
        ImageInputDispatcher.call(command:, user_message:)
      else
        MediaGenerator::MessageHandler::HandleMessage.call(command:, user_message:)
      end
    end

    memoize def successful_payment
      return unless user_message["successful_payment"]

      SuccessfulPayment.new(user_message["successful_payment"])
    end

    def handle_successful_payment
      StarsPayment::HandlePayment.call(chat_id:, name:, locale:, pack_key:, telegram_payment_charge_id:, stars_amount:)
    end
  end
end
