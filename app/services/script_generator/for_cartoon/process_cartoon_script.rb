module ScriptGenerator
  module ForCartoon
    class ProcessCartoonScript
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:)
        @chat_id = chat_id
      end

      def call
        ProcessScriptImagePrompts.call(
          chat_id:,
          scenes: scene_records,
          reference_image_url:
        )
      end

      private

      attr_reader :chat_id

      delegate :scenes, to: :cartoon_script_context
      delegate :reference_image_url, to: :cartoon_script_context

      memoize def cartoon_script_context
        CartoonScriptContext.new
      end

      memoize def script
        Script.create!(chained_references: false)
      end

      memoize def scene_records
        scenes.each_with_index.map do |scene_text, index|
          Scene.create!(script:, scene_text:, order: index + 1)
        end
      end
    end
  end
end
