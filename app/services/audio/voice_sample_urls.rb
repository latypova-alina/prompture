module Audio
  class VoiceSampleUrls
    SAMPLES_PREFIX = "audio/samples"
    DEFAULT_EXTENSION = ".mp3"

    class << self
      def url_for(slug)
        StoreMedia::Upload::StoredUrlBuilder.new(object_key: object_key_for(slug)).stored_url
      end

      def samples
        VoiceCatalog.slugs.map do |slug|
          { slug: slug.to_s, url: url_for(slug) }
        end
      end

      private

      def object_key_for(slug)
        "#{SAMPLES_PREFIX}/#{slug}#{DEFAULT_EXTENSION}"
      end
    end
  end
end
