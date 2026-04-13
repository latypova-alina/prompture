module Generator
  module Media
    module StoredMedia
      class FilenameResolver
        def initialize(media_url:)
          @media_url = media_url
        end

        def filename
          File.basename(uri.path)
        end

        private

        attr_reader :media_url

        def uri
          URI.parse(media_url)
        end
      end
    end
  end
end
