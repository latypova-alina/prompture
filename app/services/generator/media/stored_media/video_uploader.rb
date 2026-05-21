module Generator
  module Media
    module StoredMedia
      class VideoUploader
        include Memery

        def initialize(media_url:, record:)
          @media_url = media_url
          @record = record
        end

        def call
          upload_facade.upload

          record.update!(video_url: stored_url)
        end

        def stored_url
          upload_facade.stored_url
        end

        private

        attr_reader :media_url, :record

        delegate :filename, to: :filename_resolver
        delegate :category, to: :command_request

        memoize def command_request
          record.command_request
        end

        memoize def upload_facade
          StoreMedia::Upload::Facade.new(bytes: downloaded_bytes, filename:, folder:)
        end

        def folder
          "videos/#{ContentCategory.bucket_folder(category)}"
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
