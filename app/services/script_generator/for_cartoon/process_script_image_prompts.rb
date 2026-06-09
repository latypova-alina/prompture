module ScriptGenerator
  module ForCartoon
    class ProcessScriptImagePrompts
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:, scripts:)
        @chat_id = chat_id
        @scripts = scripts
      end

      def call
        scripts.each do |script|
          ProcessScriptImagePrompt.call(script:, script_processor:)
        end
      end

      private

      attr_reader :chat_id, :scripts

      memoize def script_processor
        ScriptGenerator::ProcessScript::ForImage.new(
          chat_id:,
          category: ContentCategory::CARTOON_SCRIPT
        )
      end
    end
  end
end
