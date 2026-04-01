module RecordValidators
  module CommandRequests
    class Base
      def initialize(context:)
        @context = context
      end

      def validate
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :context

      delegate :message_text, :chat_id, :picture_id, :command, :url, to: :context

      def valid_message_type?
        raise NotImplementedError
      end
    end
  end
end
