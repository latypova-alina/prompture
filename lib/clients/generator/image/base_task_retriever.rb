module Clients
  module Generator
    module Image
      class BaseTaskRetriever < ::Clients::Generator::BaseApiRequest
        include Memery

        def initialize(task_id)
          super()
          @task_id = task_id
        end

        def status
          response_body.dig("data", "status")
        end

        def image_url
          response_body.dig("data", "generated")
        end

        private

        attr_reader :task_id

        def response
          connection.get(task_id)
        end
      end
    end
  end
end
