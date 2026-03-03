module Generator
  module Video
    module CreateTask
      class ApiClient
        def initialize(api_url, payload)
          @api_url = api_url
          @payload = payload
        end

        def response
          connection.post do |req|
            req.body = payload.to_json
          end
        end

        private

        delegate :connection, to: :faraday_connection

        def faraday_connection
          ::Clients::Generator::Connection.new(api_url)
        end

        attr_reader :api_url, :payload
      end
    end
  end
end
