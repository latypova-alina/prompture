module Fal
  module Webhook
    class PublicKeys
      include Memery

      JWKS_URL = "https://rest.alpha.fal.ai/.well-known/jwks.json".freeze
      CACHE_KEY = "fal_webhook_jwks".freeze
      CACHE_TTL = 24.hours

      def self.fetch
        new.fetch
      end

      def fetch
        cached_raw_keys.map { |raw_key| OpenSSL::PKey.new_raw_public_key("ED25519", raw_key) }
      end

      private

      def cached_raw_keys
        Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_TTL) { raw_keys }
      end

      def raw_keys
        jwks.fetch("keys").map { |key| Base64.urlsafe_decode64(padded(key.fetch("x"))) }
      end

      def jwks
        raise "Fal JWKS fetch failed: #{response.status}" unless response.success?

        JSON.parse(response.body)
      end

      memoize def response
        Faraday.get(JWKS_URL)
      end

      def padded(base64url_value)
        base64url_value + ("=" * ((4 - base64url_value.length % 4) % 4))
      end
    end
  end
end
