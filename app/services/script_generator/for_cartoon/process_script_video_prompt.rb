module ScriptGenerator
  module ForCartoon
    class ProcessScriptVideoPrompt
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(script:)
        @script = script
      end

      def call
        script.update!(video_prompt: video_prompt_record)

        video_prompt_record
      end

      private

      attr_reader :script

      delegate :script_text, to: :script
      delegate :prompt, to: :video_prompt_context, prefix: :video

      memoize :video_prompt

      memoize def video_prompt_record
        VideoPrompt.create!(prompt: video_prompt)
      end

      memoize def video_prompt_context
        VideoPromptContext.new(script_text:)
      end
    end
  end
end
