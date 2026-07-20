module ScriptGenerator
  module ForCartoon
    module Processors
      class ForVideoPrompt
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(scene:)
          @scene = scene
        end

        def call
          scene.video_prompt || assign_video_prompt
        end

        private

        attr_reader :scene

        def assign_video_prompt
          scene.update!(video_prompt: VideoPrompt.create!(prompt: generated_video_prompt))

          scene.video_prompt
        end

        delegate :scene_text, to: :scene

        memoize def generated_video_prompt
          video_prompt_context.prompt
        end

        memoize def video_prompt_context
          SharedContexts::ForVideoPrompt.new(script_text: scene_text)
        end
      end
    end
  end
end
