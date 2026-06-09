module ScriptGenerator
  module ProcessScript
    class Base
      include Memery

      def initialize(chat_id:, category: nil)
        @chat_id = chat_id
        @category = category
      end

      def call(script:, subcategory: nil)
        result = ScriptProcessor::ProcessScript.call(
          script:,
          command_request:,
          chat_id:,
          subcategory:
        )

        raise result.error if result.failure?
      end

      private

      attr_reader :chat_id, :category

      memoize def command_request
        command_request_class.create!(chat_id:, user:, category:)
      end

      memoize def user
        User.find_by!(chat_id:)
      end

      def command_request_class
        raise NotImplementedError, "#{self.class.name} must implement #command_request_class"
      end
    end
  end
end
