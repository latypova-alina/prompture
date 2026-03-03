module Generator
  module Image
    module CreateTask
      class ApiClient
        include Clients::Generator::BaseApiRequest

        def initialize(api_url, payload)
          @api_url = api_url
          @payload = payload
        end

        def response
          connection.post(api_url) do |req|
            req.body = payload.to_json
          end
        end

        private

        attr_reader :api_url, :payload
      end
    end
  end
end