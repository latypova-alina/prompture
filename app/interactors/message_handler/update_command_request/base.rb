module MessageHandler
  module UpdateCommandRequest
    class Base
      include Interactor

      delegate :chat_id, :message_text, :picture_id, to: :context

      def call
        context.fail!(error: MessageTypeError) unless valid_message_type?

        raise CommandForgottenError unless last_request

        context.command_request = last_request

        update_record
      end

      private

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
