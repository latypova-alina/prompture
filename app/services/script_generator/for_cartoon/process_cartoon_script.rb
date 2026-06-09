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
        ProcessScriptImagePrompts.call(chat_id:, scripts:)
      end

      private

      attr_reader :chat_id

      delegate :scenes, to: :cartoon_script_context

      memoize def cartoon_script_context
        CartoonScriptContext.new
      end

      memoize def scripts
        scenes.map { |scene| Script.create!(script_text: scene) }
      end
    end
  end
end
