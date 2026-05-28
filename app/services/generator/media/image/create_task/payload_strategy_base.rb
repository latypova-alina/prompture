module Generator
  module Media
    module Image
      module CreateTask
        class PayloadStrategyBase
          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            { prompt: }.merge(payload_params)
          end

          def api_url
            self.class::API_URL
          end

          attr_reader :prompt

          private

          def payload_params
            raise NotImplementedError
          end
        end
      end
    end
  end
end
