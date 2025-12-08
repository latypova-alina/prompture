module MessageHandler
  module CommandImageFromReferenceRequest
    class Update
      include Interactor

      delegate :chat_id, :message_text, :picture_id, to: :context

      def call
        context.fail!(error: MessageTypeError) unless valid_message_type?

        raise CommandForgottenError unless last_request

        last_request.update!(reference_picture_id: picture_id)
      end

      private

      def valid_message_type?
        picture_id && message_text.blank?
      end

      memoize def last_request
        ::CommandImageFromReferenceRequest.where(chat_id:).order(created_at: :desc).first
      end
    end
  end
end
