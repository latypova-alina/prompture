module ScriptGenerator
  module ForBloomy
    module Payloads
      class Base < ScriptGenerator::BaseContext
        memoize def payload
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
          connection.get(endpoint_path)
        end

        def endpoint_path
          raise NotImplementedError unless self.class.const_defined?(:ENDPOINT_PATH, false)

          self.class::ENDPOINT_PATH
        end
      end
    end
  end
end
