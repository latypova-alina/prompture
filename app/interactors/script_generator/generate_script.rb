module ScriptGenerator
  class GenerateScript
    include Interactor
    include Memery

    def call
      response.success? ? handle_success : handle_error(response_error_message)
    rescue Faraday::Error => e
      handle_error(e.message)
    end

    private

    def handle_success
      context.script_array = response.body
    end

    def handle_error(message)
      context.fail!(error: ScriptGeneratorRequestError.new(message))
    end

    def response_error_message
      "Script generator API request failed with status #{response.status}."
    end

    memoize def response
      connection.get("/generate")
    end

    def connection
      Faraday.new(
        url: ENV.fetch("SCRIPT_GENERATOR_API_URL"),
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV.fetch('SCRIPT_GENERATOR_API_KEY')}"
        }
      )
    end
  end
end
