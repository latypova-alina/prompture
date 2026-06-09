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

      delegate :scenes, to: :motivation_prompt_context

      attr_reader :chat_id, :script

      def process_scene(scene)
        script_processor.call(script: scene.prompt, subcategory: scene.subcategory)
      end

      memoize def motivation_prompt_context
        MotivationPromptContext.new(script:)
      end

      memoize def script_processor
        ScriptGenerator::ProcessScript::ForVideo.new(chat_id:, category: ContentCategory::MOTIVATION)
      end
    end
  end
end
