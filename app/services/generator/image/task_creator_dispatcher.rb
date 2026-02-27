module Generator
  module Image
    class TaskCreatorDispatcher
      include Memery

      STRATEGIES = {
        "mystic_image" => Mystic::PayloadStrategyForCreate,
        "gemini_image" => Gemini::PayloadStrategyForCreate,
        "imagen_image" => Imagen::PayloadStrategyForCreate
      }.freeze

      def self.call(...)
        new(...).call
      end

      def initialize(request)
        @request = request
      end

      def call
        TaskCreator.call(request, strategy)
      end

      private

      attr_reader :request

      delegate :parent_request, to: :request

      memoize def strategy
        STRATEGIES.fetch(request.processor).new(parent_request.parent_prompt)
      end
    end
  end
end
