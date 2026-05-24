module Generator
  module Media
    module StoredMedia
      class VideoUploader
        include Memery

        def initialize(media_url:, record:)
          @media_url = media_url
          @record = record
        end

        delegate :stored_url, to: :upload_facade

        def call
          upload_facade.upload

          record.update!(video_url: stored_url)

          register_stored_video
        end

        private

        attr_reader :media_url, :record

        def register_stored_video
          StoreVideo::Registrar.call(record:, video_url: stored_url)
        end

        delegate :filename, to: :filename_resolver
        delegate :downloaded_bytes, to: :remote_url_downloader
        delegate :command_request, to: :record
        delegate :category, to: :command_request

        memoize def upload_facade
          StoreMedia::Upload::Facade.new(bytes: downloaded_bytes, filename:, folder:)
        end

        def folder
          "videos/#{ContentCategory.bucket_folder(category)}"
        end

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
