module ScriptGenerator
  class SendRandomCharacterJob < ApplicationJob
    include Memery
    include JobErrorHandler

    def perform(chat_id)
      @chat_id = chat_id

      response.success? ? handle_success : notify_script_generator_error(chat_id:)
    rescue Faraday::Error => e
      notify_script_generator_error(chat_id:, error: e)
    end

    private

    attr_reader :chat_id

    def handle_success
      return notify_script_generator_error(chat_id:) if character_description.blank?

      Telegram.bot.send_message(chat_id:, text: character_description)
    end

    def character_description
      response_payload["character_description"].to_s
    end

    def response_payload
      body = response.body

      body.is_a?(String) ? JSON.parse(body) : body
    end

    memoize def response
      script_generator_connection.get("/random_character")
    end

    def script_generator_connection
      ScriptGenerator::Connection.call
    end
  end
end
