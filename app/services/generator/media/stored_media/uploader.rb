module Generator
  module Media
    module StoredMedia
      class Uploader
        include Memery

        def initialize(media_url:, record:)
          @media_url = media_url
          @record = record
        end

        def call
          upload_facade.upload_image

          StoreImage::StoredImageUpdater.call(record:, image_url: stored_url)
        end

        def stored_url
          upload_facade.stored_url
        end

        private

        attr_reader :media_url, :record

        delegate :filename, to: :filename_resolver

        memoize def upload_facade
          StoreImage::Upload::Facade.new(bytes: downloaded_bytes, filename:)
        end

        def downloaded_bytes
          StoreImage::Download::UrlImageDownloader.call(media_url)
        end

        memoize def filename_resolver
          FilenameResolver.new(media_url:)
        end
      end
    end
  end
end
