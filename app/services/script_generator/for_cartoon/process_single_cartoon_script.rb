module ScriptGenerator
  module ForCartoon
    class ProcessSingleCartoonScript
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:, category: ContentCategory::CARTOON_SCRIPT)
        @chat_id = chat_id
        @category = category
      end

      def call
        ProcessScriptImagePrompts.call(
          chat_id:,
          scripts:,
          reference_image_url:,
          category:
        )
      end

      private

      attr_reader :chat_id, :category

      delegate :scenes, to: :single_cartoon_script_context
      delegate :reference_image_url, to: :single_cartoon_script_context

      memoize def single_cartoon_script_context
        SingleCartoonScriptContext.new
      end

      memoize def scripts
        scenes.map { |scene| Script.create!(script_text: scene) }
      end
    end
  end
end
