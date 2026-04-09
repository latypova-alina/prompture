require "net/http"

module StoreImage
  module Download
    class Facade
      include Memery

      def initialize(record)
        @record = record
      end

      def bytes
        resolved_source.first
      end

      def filename
        resolved_source.last
      end

      private

      attr_reader :record

      memoize def resolved_source
        case record
        when ImageUrlMessage
          [download_from_url(record.image_url), "image_url_#{record.id}.jpg"]
        when PictureMessage
          [download_picture_bytes(record.picture_id), "picture_#{record.id}.jpg"]
        end
      end

      def download_from_url(url)
        UrlImageDownloader.call(url)
      end

      def download_picture_bytes(picture_id)
        TelegramPictureDownloader.call(picture_id:)
      end
    end
  end
end
