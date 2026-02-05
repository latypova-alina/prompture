module RecordUpdaters
  module CommandRequests
    class Base
      include Memery

      def initialize(message_text, chat_id, picture_id = nil)
        @chat_id = chat_id
        @message_text = message_text
        @picture_id = picture_id
      end

      def command_request
        raise MessageTypeError unless valid_message_type?
        raise CommandRequestForgottenError unless last_request

        update_record
        last_request
      end

      private

      attr_reader :message_text, :chat_id, :picture_id

      def update_record
        raise NotImplementedError
      end

      def valid_message_type?
        raise NotImplementedError
      end

      memoize def last_request
        raise NotImplementedError
      end
    end
  end
end
