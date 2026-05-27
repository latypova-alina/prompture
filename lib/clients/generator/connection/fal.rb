module Clients
  module Generator
    module Connection
      class Fal
        include Memery

        def initialize(url)
          @url = url
        end

        memoize def connection
          Faraday.new(url:) do |f|
            f.headers["Content-Type"] = "application/json"
            f.headers["Accept"] = "application/json"
            f.headers["Authorization"] = "Key #{ENV.fetch('FAL_API_KEY')}"

            f.request :url_encoded
            f.response :logger, nil, { bodies: true }

            f.adapter Faraday.default_adapter
          end
        end

        private

        attr_reader :url
      end
    end
  end
end
