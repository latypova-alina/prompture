module ScriptGenerator
  module ForMotivation
    class ProcessScriptVideoPrompts
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:, script:)
        @chat_id = chat_id
        @script = script
      end

      def call
        prompts.each { |prompt| script_processor.call(script: prompt) }
      end

      private

      attr_reader :chat_id, :script

      delegate :prompts, to: :narration_video_prompts_context

      memoize def narration_video_prompts_context
        NarrationVideoPromptsContext.new(script:)
      end

      memoize def script_processor
        ScriptGenerator::ProcessScript.new(chat_id:, category: ContentCategory::MOTIVATION)
      end
    end
  end
end
