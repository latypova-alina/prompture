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
          strategies.fetch(processor).new(prompt)
        end

        private

        attr_reader :request

        delegate :parent_request, :processor, to: :request

        def prompt
          return parent_request.parent_prompt if parent_request.respond_to?(:parent_prompt)

          nil
        end

        def strategies
          raise NotImplementedError
        end
      end
    end
  end
end
