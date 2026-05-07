module ScriptGenerator
  class SendScriptTemplatesJob < ApplicationJob
    include Memery

    def perform(chat_id)
      @chat_id = chat_id

      response.success? ? handle_success : notify_error
    rescue Faraday::Error
      notify_error
    end

    private

    attr_reader :chat_id

    def handle_success
      Telegram.bot.send_message(chat_id:, text: template_names.join("\n"))
    end

    memoize def response
      script_generator_connection.get("/templates")
    end

    def template_names
      payload = response.body.is_a?(String) ? JSON.parse(response.body) : response.body

      payload["file_names"] || []
    end

    def notify_error
      Telegram.bot.send_message(chat_id:, text: I18n.t("errors.script_generator_request_failed"))
    end

    def script_generator_connection
      ScriptGenerator::Connection.call
    end
  end
end
