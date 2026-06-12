module ScriptGenerator
  module ForCartoon
    class ProcessSingleCartoonScript
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
          scripts:,
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

      memoize def scripts
        [Script.create!(script_text: scenes.sample)]
      end
    end
  end
end
