module ScriptGenerator
  module ForCartoon
    class CreateSceneImagePrompt
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(scene:)
        @scene = scene
      end

      def call
        scene.update!(image_prompt: image_prompt_record)

        image_prompt_record
      end

      private

      attr_reader :scene

      delegate :scene_text, to: :scene

      memoize def image_prompt_record
        ImagePrompt.create!(prompt: image_prompt)
      end

      memoize def image_prompt
        image_prompt_context.prompt
      end

      memoize def image_prompt_context
        ImagePromptContext.new(script_text: scene_text)
      end
    end
  end
end
