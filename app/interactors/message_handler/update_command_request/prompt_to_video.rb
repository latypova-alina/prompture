module MessageHandler
  module UpdateCommandRequest
    class PromptToVideo < Base
      private

      def update_record
        last_request.update!(prompt: message_text)
      end

      def valid_message_type?
        message_text && picture_id.blank? && last_request.picture_id.blank?
      end

      memoize def last_request
        ::CommandPromptToVideoRequest.where(chat_id:).order(created_at: :desc).first
      end
    end
  end
end
