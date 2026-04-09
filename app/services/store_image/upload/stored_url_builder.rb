module StoreImage
  module Upload
    class StoredUrlBuilder
      include Memery

      def initialize(object_key:)
        @object_key = object_key
      end

      def stored_url
        "#{base_url}/#{object_key}"
      end

      private

      attr_reader :object_key

      def base_url
        ENV.fetch("INTERNAL_BUCKET_BASE_URL")
      end
    end
  end
end
