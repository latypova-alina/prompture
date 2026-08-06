module Audio
  class VoiceSampleUrls
    SAMPLES_PREFIX = "admin/audio/samples".freeze
    DEFAULT_EXTENSION = ".mp3".freeze

    class << self
      def url_for(slug)
        S3::UrlBuilder.new(object_key: object_key_for(slug)).stored_url
      end

      def samples
        slugs = available_slugs

        VoiceCatalog.slugs.filter_map do |slug|
          next unless slugs.include?(slug.to_s)

          { slug: slug.to_s, url: url_for(slug) }
        end
      end

      private

      delegate :object_keys, to: :object_keys_fetcher

      def object_key_for(slug)
        "#{SAMPLES_PREFIX}/#{slug}#{DEFAULT_EXTENSION}"
      end

      def available_slugs
        # Array#include? is less efficient than Set#include?, that's why we use a Set.

        object_keys.filter_map { |key| slug_from_key(key) }.to_set
      end

      def slug_from_key(key)
        return unless key.end_with?(DEFAULT_EXTENSION)

        File.basename(key, DEFAULT_EXTENSION)
      end

      def object_keys_fetcher
        S3::ObjectKeysFetcher.new(prefix: "#{SAMPLES_PREFIX}/")
      end
    end
  end
end
