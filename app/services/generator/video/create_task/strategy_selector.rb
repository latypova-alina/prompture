module Generator
  module Video
    module CreateTask
      class StrategySelector
        include Memery

        STRATEGIES = {
          "kling_2_1_pro_image_to_video" => KlingPayloadStrategy
        }.freeze

        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def strategy
          STRATEGIES.fetch(processor).new(parent_prompt)
        end

        private

        attr_reader :request

        delegate :parent_request, :processor, to: :request
        delegate :parent_prompt, to: :parent_request
      end
    end
  end
end
