module Generator
  module Media
    module StoredMedia
      class AudioUploader
        include Memery

        def initialize(media_url:, record:)
          @media_url = media_url
          @record = record
        end

        def call
          upload_facade.upload

          record.update!(audio_url: stored_url)
        end

        def stored_url
          upload_facade.stored_url
        end

        private

        attr_reader :media_url, :record

        delegate :filename, to: :filename_resolver
        delegate :downloaded_bytes, to: :remote_url_downloader

        memoize def upload_facade
          StoreMedia::Upload::Facade.new(bytes: downloaded_bytes, filename:, folder:)
        end

        def folder
          ContentCategory.audio_bucket_folder(category)
        end

        delegate :category, to: :command_request, allow_nil: true
        delegate :command_request, to: :record

        memoize def remote_url_downloader
          StoreImage::Download::RemoteUrlDownloader.new(media_url)
        end

        memoize def filename_resolver
          FilenameResolver.new(media_url:)
        end
      end
    end
  end
end
