module ScriptGenerator
  class MotivationScriptContext
    include Memery

    def initialize(chat_id:, language: "en")
      @chat_id = chat_id
      @language = language
    end

    def script_text
      handle_error

      parsed_script_text
    rescue Faraday::Error => e
      raise ScriptGeneratorRequestError, e.message
    end

    private

    attr_reader :chat_id, :language

    def handle_error
      raise ScriptGeneratorRequestError if !response.success? || parsed_script_text.blank?
    end

    memoize def parsed_script_text
      response_payload["script"].to_s
    end

    def response_payload
      body = response.body

      body.is_a?(String) ? JSON.parse(body) : body
    rescue JSON::ParserError
      {}
    end

    memoize def response
      connection.get("/motivation_script", { language: })
    end

    def connection
      ScriptGenerator::Connection.call
    end
  end
end
