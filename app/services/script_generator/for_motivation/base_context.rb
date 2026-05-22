module ScriptGenerator
  module ForMotivation
    module BaseContext
      extend ActiveSupport::Concern

      included do
        include Memery

        delegate :body, to: :response, prefix: true

        memoize def parsed_json_body
          return response_body unless response_body.is_a?(String)

          JSON.parse(response_body)
        rescue JSON::ParserError
          nil
        end
      end

      private

      def connection
        ScriptGenerator::Connection.call
      end
    end
  end
end
