module ScriptGenerator
  module ForCartoon
    class CartoonProblemSolutionScriptPayload < ScriptGenerator::BaseContext
      def self.call(...)
        new(...).call
      end

      def call
        handle_error

        parsed_json_body || {}
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      def handle_error
        raise ScriptGeneratorRequestError unless response.success?
      end

      memoize def response
        connection.get("/cartoon_problem_solution_script")
      end
    end
  end
end
