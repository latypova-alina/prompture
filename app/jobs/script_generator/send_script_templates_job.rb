module ScriptGenerator
  class SendScriptTemplatesJob < ApplicationJob
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
      Telegram.bot.send_message(chat_id:, text: template_names.join("\n"))

      delete_processing_message
    end

    def delete_processing_message
      TelegramIntegration::DeleteBotTelegramMessage.call(request: User.find_by(chat_id:))
    end

    memoize def response
      script_generator_connection.get("/templates")
    end

    def template_names
      payload = response.body.is_a?(String) ? JSON.parse(response.body) : response.body

      payload["file_names"] || []
    end

    def script_generator_connection
      ScriptGenerator::Connection.call
    end
  end
end
