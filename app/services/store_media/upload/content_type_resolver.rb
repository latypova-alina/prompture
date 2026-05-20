module StoreMedia
  module Upload
    class ContentTypeResolver
      include Memery

      CONTENT_TYPES = {
        ".mp3" => "audio/mpeg",
        ".wav" => "audio/wav",
        ".ogg" => "audio/ogg",
        ".m4a" => "audio/mp4",
        ".aac" => "audio/aac"
      }.freeze

      def initialize(filename:)
        @filename = filename
      end

      memoize def content_type
        CONTENT_TYPES.fetch(extension, "application/octet-stream")
      end

      private

      attr_reader :filename

      def extension
        File.extname(filename).downcase
      end
    end
  end
end
