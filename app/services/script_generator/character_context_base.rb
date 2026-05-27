module ScriptGenerator
  class CharacterContextBase
    include Memery

    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def character_description
      handle_error

      parsed_character_description
    rescue Faraday::Error => e
      raise ScriptGeneratorRequestError, e.message
    end

    private

    attr_reader :chat_id

    def endpoint_path
      raise NotImplementedError
    end

    def handle_error
      raise ScriptGeneratorRequestError if !response.success? || parsed_character_description.blank?
    end

    memoize def parsed_character_description
      response_payload["character_description"].to_s
    end

    def response_payload
      body = response.body

      body.is_a?(String) ? JSON.parse(body) : body
    end

    memoize def response
      connection.get(endpoint_path)
    end

    def connection
      ScriptGenerator::Connection.call
    end
  end
end
