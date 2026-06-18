module Generator
  module Media
    class StatusUrlResolver
      def initialize(fal_request_id:, processor:)
        @fal_request_id = fal_request_id
        @processor = processor
      end

      def status_url
        "#{base_url}/requests/#{fal_request_id}/status"
      end

      def base_url
        FalQueueBaseUrls::BASE_URLS.fetch(processor)
      end

      private

      attr_reader :fal_request_id, :processor
    end
  end
end
