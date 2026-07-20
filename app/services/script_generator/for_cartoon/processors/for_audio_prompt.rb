module ScriptGenerator
  module ForCartoon
    module Processors
      class ForAudioPrompt
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(script_text:, video_prompt:)
          @script_text = script_text
          @video_prompt = video_prompt
        end

        def call
          video_prompt.audio_prompts.create!(prompt:)
        end

        private

        attr_reader :script_text, :video_prompt

        delegate :prompt, to: :audio_prompt_context

        memoize def audio_prompt_context
          SharedContexts::ForAudioPrompt.new(script_text:)
        end
      end
    end
  end
end
