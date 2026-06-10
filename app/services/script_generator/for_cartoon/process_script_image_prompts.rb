module ScriptGenerator
  module ForCartoon
    class ProcessScriptImagePrompts
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:, scripts:, reference_image_url:)
        @chat_id = chat_id
        @scripts = scripts
        @reference_image_url = reference_image_url
      end

      def call
        scripts.each do |script|
          ProcessScriptImagePrompt.call(script:, script_processor:)
        end
      end

      private

      attr_reader :chat_id, :scripts, :reference_image_url

      memoize def script_processor
        ScriptGenerator::ProcessScript::ForEditImage.new(
          chat_id:,
          category: ContentCategory::CARTOON_SCRIPT,
          reference_image_url:
        )
      end
    end
  end
end
