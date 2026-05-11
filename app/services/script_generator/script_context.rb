module ScriptGenerator
  class ScriptContext
    include Memery

    def initialize(chat_id:, template_name: nil)
      @chat_id = chat_id
      @template_name = template_name
    end

    def script_array
      raise ScriptGeneratorRequestError, response.body unless response.success?

      response.body
    rescue Faraday::Error => e
      raise ScriptGeneratorRequestError, e.message
    end

    private

    memoize def response
      connection.get("/generate", { template_name: })
    end

    def connection
      ScriptGenerator::Connection.call
    end

    attr_reader :chat_id, :template_name
  end
end
