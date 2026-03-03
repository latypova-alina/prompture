module Generator
  module Media
    module CreateTask
      class StrategySelectorBase
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def strategy
          strategies.fetch(processor).new(parent_prompt)
        end

        private

        attr_reader :request

        delegate :parent_request, :processor, to: :request
        delegate :parent_prompt, to: :parent_request

        def strategies
          raise NotImplementedError
        end
      end
    end
  end
end
