module RecordValidators
  module CommandRequests
    class ImageToVideo < Base
      private

      def valid_message_type?
        picture_only_provided? || text_only_provided?
      end

      def picture_only_provided?
        last_request.picture_id.blank? && picture_id && message_text.blank?
      end

      def text_only_provided?
        last_request.prompt.blank? && message_text && picture_id.blank?
      end
    end
  end
end
