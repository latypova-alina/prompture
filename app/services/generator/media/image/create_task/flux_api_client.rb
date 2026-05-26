module Generator
  module Media
    module Image
      module CreateTask
        class FluxApiClient < Generator::Media::CreateTask::ApiClientBase
          private

          def faraday_connection
            ::Clients::Generator::Connection::Flux.new(api_url)
          end
        end
      end
    end
  end
end
