module Generator
  module Media
    module Video
      module RetrieveTask
        class ApiClient
          def initialize(task_id, api_url)
            @task_id = task_id
            @api_url = api_url
          end

          def api_response
            connection.get("#{api_url}/#{task_id}")
          end

          private

          delegate :connection, to: :faraday_connection

          def faraday_connection
            ::Clients::Generator::Connection.new(api_url)
          end

          attr_reader :task_id, :api_url
        end
      end
    end
  end
end
