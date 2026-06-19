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
        script.video_prompt || assign_video_prompt
      end

      private

      attr_reader :script

      def assign_video_prompt
        script.update!(video_prompt: VideoPrompt.create!(prompt: generated_video_prompt))

        script.video_prompt
      end

      delegate :script_text, to: :script

      memoize def generated_video_prompt
        video_prompt_context.prompt
      end

      memoize def video_prompt_context
        VideoPromptContext.new(script_text:)
      end
    end
  end
end
