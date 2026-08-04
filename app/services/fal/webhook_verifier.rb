module Fal
  class WebhookVerifier
    include Memery

    MAX_CLOCK_SKEW = 300 # seconds; fal.ai recommends rejecting stale webhooks as replay protection

    def initialize(headers:, body:)
      @headers = headers
      @body = body
    end

    def valid?
      header_reader.present? && timely? && signature_valid?
    end

    private

    attr_reader :headers, :body

    delegate :request_id, :user_id, :timestamp, :signature, to: :header_reader

    memoize def header_reader
      Webhook::HeaderReader.new(headers:)
    end

    def timely?
      (Time.now.to_i - timestamp.to_i).abs <= MAX_CLOCK_SKEW
    end

    def signature_valid?
      public_keys.any? { |key| key.verify(nil, signature_bytes, message) }
    end

    def signature_bytes
      [signature].pack("H*")
    end

    def message
      Webhook::SignedMessage.new(request_id:, user_id:, timestamp:, body:).to_s
    end

    memoize def public_keys
      Webhook::PublicKeys.fetch
    end
  end
end
