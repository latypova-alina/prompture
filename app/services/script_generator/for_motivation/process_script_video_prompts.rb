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
        scenes.each { |scene| process_scene(scene) }
      end

      private

      attr_reader :chat_id, :script

      def process_scene(scene)
        script_processor.call(script: scene.prompt, subcategory: scene.subcategory)
      end

      delegate :scenes, to: :narration_video_prompts_context

      memoize def narration_video_prompts_context
        NarrationVideoPromptsContext.new(script:)
      end

      memoize def script_processor
        ScriptGenerator::ProcessScript.new(chat_id:, category: ContentCategory::MOTIVATION)
      end
    end
  end
end
