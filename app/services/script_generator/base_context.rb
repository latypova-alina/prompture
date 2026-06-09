module ScriptGenerator
  class BaseContext
    include Memery

    delegate :body, to: :response, prefix: true

    private

    def connection
      ScriptGenerator::Connection.call
    end

    memoize def parsed_json_body
      return response_body unless response_body.is_a?(String)

      JSON.parse(response_body)
    rescue JSON::ParserError
      nil
    end

    def response
      raise NotImplementedError
    end
  end
end
