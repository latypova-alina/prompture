module Clients
  module Generator
    module Image
      class BaseTaskCreator < ::Clients::Generator::BaseApiRequest
        include Memery

        def initialize(prompt)
          super()
          @prompt = prompt
        end

        private

        attr_reader :prompt

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
