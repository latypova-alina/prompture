module Generator
  module Image
    module RetrieveTask
      class ApiClient
        include Clients::Generator::BaseApiRequest

        def initialize(task_id, api_url)
          @task_id = task_id
          @api_url = api_url
        end

        def api_response
          connection.get("#{api_url}/#{task_id}")
        end

        private

        attr_reader :task_id, :api_url
      end
    end
  end
end
