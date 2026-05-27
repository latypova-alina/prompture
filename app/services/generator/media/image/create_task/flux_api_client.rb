require "cgi"

module Generator
  module Media
    module Image
      module CreateTask
        class FluxApiClient < Generator::Media::CreateTask::ApiClientBase
          def response
            connection.post do |req|
              req.url "#{api_url}?fal_webhook=#{CGI.escape(webhook_url)}"
              req.body = request_payload.to_json
            end
          end

          private

          def faraday_connection
            ::Clients::Generator::Connection::Fal.new(api_url)
          end

          def webhook_url
            payload.fetch(:fal_webhook)
          end

          def request_payload
            payload.except(:fal_webhook)
          end
        end
      end
    end
  end
end
