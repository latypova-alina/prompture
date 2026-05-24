module ScriptGenerator
  module ForMotivation
    class MotivationPromptContext
      include BaseContext

      def initialize(script:)
        @script = script
      end

      def scenes
        handle_error

        parsed_scenes
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :script

      delegate :parsed_scenes, to: :scenes_parser

      def handle_error
        return if valid_response?

        raise ScriptGeneratorRequestError, response_body.to_s
      end

      def valid_response?
        response.success? && parsed_scenes.present?
      end

      memoize def scenes_parser
        ScenesParser.new(parsed_response_body: parsed_json_body)
      end

      memoize def response
        connection.post("/motivation_prompt") do |request|
          request.body = { script: }.to_json
        end
      end
    end
  end
end
