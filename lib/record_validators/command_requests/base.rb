module RecordValidators
  module CommandRequests
    class Base
      def initialize(message_text, chat_id, parent_request, picture_id = nil)
        @chat_id = chat_id
        @message_text = message_text
        @parent_request = parent_request
        @picture_id = picture_id
      end

      def validate
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :message_text, :chat_id, :picture_id, :parent_request

      def valid_message_type?
        raise NotImplementedError
      end
    end
  end
end
