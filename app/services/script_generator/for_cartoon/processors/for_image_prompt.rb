module ScriptGenerator
  module ForCartoon
    module Processors
      class ForImagePrompt
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(scene:, script_processor:)
          @scene = scene
          @script_processor = script_processor
        end

        def call
          script_processor.call(image_prompt_record:)

          scene.update!(image_prompt: image_prompt_record)
        end

        private

        attr_reader :scene, :script_processor

        delegate :scene_text, to: :scene

        memoize def image_prompt
          image_prompt_context.prompt
        end

        memoize def image_prompt_record
          ImagePrompt.create!(prompt: image_prompt)
        end

        memoize def image_prompt_context
          SharedContexts::ForImagePrompt.new(script_text: scene_text)
        end
      end
    end
  end
end
