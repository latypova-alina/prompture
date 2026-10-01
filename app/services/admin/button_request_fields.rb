module Admin
  # Column fields plus the computed values only a button request has (process name, cost,
  # audio prompt text, the bot's Telegram message).
  class ButtonRequestFields
    def self.call(...)
      new(...).call
    end

    def initialize(button_request)
      @button_request = button_request
    end

    def call
      Admin::RecordFields.call(button_request).merge(computed_fields, audio_prompt_fields, telegram_fields)
    end

    private

    attr_reader :button_request

    delegate :processor, :humanized_process_name, :cost, :bot_telegram_message, to: :button_request

    def computed_fields
      { "processor" => processor, "process_name" => humanized_process_name, "cost" => cost }
    end

    def audio_prompt_fields
      return {} unless button_request.respond_to?(:audio_prompt)

      { "audio_prompt" => button_request.audio_prompt&.prompt }
    end

    def telegram_fields
      return {} if bot_telegram_message.blank?

      { "bot_message_chat_id" => bot_telegram_message.chat_id,
        "bot_message_tg_message_id" => bot_telegram_message.tg_message_id }
    end
  end
end
