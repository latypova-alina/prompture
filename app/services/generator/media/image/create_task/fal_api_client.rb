require "cgi"

module Generator
  module Media
    module Image
      module CreateTask
        class FalApiClient < Generator::Media::CreateTask::ApiClientBase
          def initialize(api_url, payload, webhook_url)
            @api_url = api_url
            @payload = payload
            @webhook_url = webhook_url
          end

          def response
            connection.post do |req|
              req.url "#{api_url}?fal_webhook=#{CGI.escape(webhook_url)}"
              req.body = payload.to_json
            end
          end

          private

          attr_reader :webhook_url

          def faraday_connection
            ::Clients::Generator::Connection::Fal.new(api_url)
          end
        end
      end
    end
  end
end
