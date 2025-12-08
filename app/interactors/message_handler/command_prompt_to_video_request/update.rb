module MessageHandler
  module CommandPromptToVideoRequest
    class Update
      include Interactor

      delegate :chat_id, :message_text, :picture_id, to: :context

      def call
        context.fail!(error: MessageTypeError) unless valid_message_type?

        raise CommandForgottenError unless last_request

        last_request.update!(prompt: message_text)
      end

      private

      def valid_message_type?
        message_text && picture_id.blank?
      end

      memoize def last_request
        ::CommandPromptToImageRequest.where(chat_id:).order(created_at: :desc).first
      end
    end
  end
end
