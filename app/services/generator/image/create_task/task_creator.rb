module Generator
  module Image
    module CreateTask
      class TaskCreator
        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def call
          raise Freepik::ResponseError unless response.success?
        end

        private

        attr_reader :request

        delegate :strategy, to: :strategy_selector
        delegate :response, to: :api_client
        delegate :api_url, to: :strategy
        delegate :final_payload, to: :payload_composer

        def api_client
          ApiClient.new(api_url, final_payload)
        end

        def payload_composer
          PayloadComposer.new(request, strategy)
        end

        def strategy_selector
          StrategySelector.new(request)
        end
      end
    end
  end
end
