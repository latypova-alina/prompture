module StoreImage
  class InternalBucketUploader
    include Memery

    def initialize(bytes:, filename:)
      @bytes = bytes
      @filename = filename
    end

    def upload
      object_uploader.upload
    end

    def stored_url
      "#{base_url}/#{object_key}"
    end

    private

    attr_reader :bytes, :filename

    delegate :object_key, to: :object_key_builder
    delegate :content_type, to: :content_type_resolver

    memoize def object_uploader
      S3ObjectUploader.new(bytes:, object_key:, content_type:)
    end

    memoize def object_key_builder
      ObjectKeyBuilder.new(filename:)
    end

    memoize def content_type_resolver
      ContentTypeResolver.new(filename:)
    end

    def base_url
      ENV.fetch("INTERNAL_BUCKET_BASE_URL")
    end

  end
end
