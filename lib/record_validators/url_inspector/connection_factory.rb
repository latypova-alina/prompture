require "faraday"

module RecordValidators
  module UrlInspector
    class ConnectionFactory
      REQUEST_TIMEOUT = 5

      def build(uri)
        base_url = "#{uri.scheme}://#{uri.host}"
        base_url += ":#{uri.port}" unless [80, 443].include?(uri.port)

        Faraday.new(url: base_url) do |conn|
          conn.options.open_timeout = REQUEST_TIMEOUT
          conn.options.timeout = REQUEST_TIMEOUT
        end
      end
    end
  end
end
