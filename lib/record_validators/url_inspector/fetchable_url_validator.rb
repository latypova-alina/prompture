require "faraday"

module RecordValidators
  module UrlInspector
    class FetchableUrlValidator
      FETCH_TIMEOUT = 3
      USER_AGENT = "Mozilla/5.0 (compatible; Prompture/1.0)".freeze

      def initialize(url:)
        @url = url
      end

      def valid?
        response = Faraday.get(url) do |req|
          req.headers["User-Agent"] = USER_AGENT
          req.options.timeout = FETCH_TIMEOUT
          req.options.open_timeout = FETCH_TIMEOUT
        end

        response.success?
      rescue StandardError
        false
      end

      private

      attr_reader :url
    end
  end
end
