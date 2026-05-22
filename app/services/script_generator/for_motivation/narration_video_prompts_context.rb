module ScriptGenerator
  module ForMotivation
    class NarrationVideoPromptsContext < PromptsBaseContext
      def initialize(script:)
        super()
        @script = script
      end

      private

      attr_reader :script

      memoize def response
        connection.post("/narration_video_prompts") do |request|
          request.body = { script: }.to_json
        end
      end
    end
  end
end
