module StoreMedia
  module Upload
    class Facade
      include Memery

      def initialize(bytes:, filename:, folder:)
        @bytes = bytes
        @filename = filename
        @folder = folder
      end

      def upload
        object_uploader.upload
      end

      def stored_url
        stored_url_builder.stored_url
      end

      private

      attr_reader :bytes, :filename, :folder

      delegate :object_key, to: :object_key_builder
      delegate :content_type, to: :content_type_resolver

      memoize def object_uploader
        StoreImage::Upload::S3ObjectUploader.new(bytes:, object_key:, content_type:)
      end

      memoize def stored_url_builder
        StoreImage::Upload::StoredUrlBuilder.new(object_key:)
      end

      memoize def object_key_builder
        StoreImage::Upload::ObjectKeyBuilder.new(filename:, folder:)
      end

      memoize def content_type_resolver
        ContentTypeResolver.new(filename:)
      end
    end
  end
end
