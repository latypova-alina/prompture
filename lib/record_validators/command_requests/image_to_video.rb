module RecordValidators
  module CommandRequests
    class ImageToVideo < Base
      private

      def valid_message_type?
        url_provided? || picture_provided?
      end

      def picture_provided?
        picture_id.present?
      end

      def url_provided?
        url.present?
      end
    end
  end
end
