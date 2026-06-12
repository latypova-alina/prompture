module ScriptGenerator
  module ForCartoon
    class ProcessCartoonShortsScript
      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:)
        @chat_id = chat_id
      end

      def call
        ProcessSingleCartoonScript.call(
          chat_id:,
          category: ContentCategory::CARTOON_SHORTS_SCRIPT
        )
      end

      private

      attr_reader :chat_id
    end
  end
end
