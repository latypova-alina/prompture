module Clients
  module Generator
    module Video
      class BaseTaskCreator < ::Clients::Generator::BaseApiRequest
        include Memery

        def initialize(image_url, prompt)
          super()
          @image_url = image_url
          @prompt = prompt
        end

        def task_id
          response_body.dig("data", "task_id")
        end

        private

        attr_reader :prompt, :image_url

        memoize def response
          connection.post { |req| req.body = payload.to_json }
        end

        def payload
          raise NotImplementedError
        end
      end
    end
  end
end
