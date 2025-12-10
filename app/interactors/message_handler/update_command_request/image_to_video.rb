module MessageHandler
  module UpdateCommandRequest
    class ImageToVideo < Base
      private

      def update_record
        last_request.update!(reference_picture_id: picture_id) if picture_only_provided?

        last_request.update!(prompt: message_text) if text_only_provided?
      end

      def valid_message_type?
        picture_only_provided? || text_only_provided?
      end

      def picture_only_provided?
        last_request.picture_id.blank? && picture_id && message_text.blank?
      end

      def text_only_provided?
        last_request.prompt.blank? && message_text && picture_id.blank?
      end

      memoize def last_request
        ::CommandImageToVideoRequest.where(chat_id:).order(created_at: :desc).first
      end
    end
  end
end
