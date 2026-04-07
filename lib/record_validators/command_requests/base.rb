module RecordValidators
  module CommandRequests
    class Base
      def initialize(message_text:, picture_id:)
        @message_text = message_text
        @picture_id = picture_id
      end

      def validate
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :message_text, :picture_id

      def valid_message_type?
        raise NotImplementedError
      end
    end
  end
end
