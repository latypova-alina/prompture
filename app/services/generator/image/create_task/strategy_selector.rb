module Generator
  module Image
    module CreateTask
      class StrategySelector
        include Memery

        STRATEGIES = {
          "mystic_image" => MysticPayloadStrategy,
          "gemini_image" => GeminiPayloadStrategy,
          "imagen_image" => ImagenPayloadStrategy
        }.freeze

        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def strategy
          STRATEGIES.fetch(request.processor).new(parent_request.parent_prompt)
        end

        private

        attr_reader :request

        delegate :parent_request, to: :request
      end
    end
  end
end
