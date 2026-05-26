module Generator
  module Media
    module CreateTask
      class TaskCreatorBase
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def call
          return if response.success?

          raise Freepik::DailyLimitExceeded if response.status == 429

          raise Freepik::ResponseError
        end

        private

        attr_reader :request

        delegate :strategy, to: :strategy_selector
        delegate :api_url, to: :strategy
        delegate :final_payload, to: :payload_composer

        def api_client
          api_client_class.new(api_url, final_payload)
        end

        def payload_composer
          payload_composer_class.new(request, strategy)
        end

        def strategy_selector
          strategy_selector_class.new(request)
        end

        memoize def response
          api_client.response
        end

        def api_client_class
          raise NotImplementedError
        end

        def payload_composer_class
          raise NotImplementedError
        end

        def strategy_selector_class
          raise NotImplementedError
        end
      end
    end
  end
end
