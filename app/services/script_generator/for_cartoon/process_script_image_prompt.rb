module ScriptGenerator
  module ForCartoon
    class ProcessScriptImagePrompt
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(script:, script_processor:)
        @script = script
        @script_processor = script_processor
      end

      def call
        script_processor.call(image_prompt_record:)

        script.update!(image_prompt: image_prompt_record)
      end

      private

      attr_reader :script, :script_processor

      delegate :script_text, to: :script

      memoize def image_prompt
        image_prompt_context.image_prompt
      end

      memoize def image_prompt_record
        ImagePrompt.create!(prompt: image_prompt)
      end

      memoize def image_prompt_context
        ImagePromptContext.new(script_text:)
      end
    end
  end
end
