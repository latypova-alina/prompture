module MediaGenerator
  module GenerationStatus
    class PresenterSelector
      CANCELLABLE_REQUESTS = [
        ButtonVideoProcessingRequest
      ].freeze

      def initialize(request:)
        @request = request
      end

      def presenter
        return ForCancellablePresenter.new(request) if cancellable?

        ForNonCancellablePresenter.new(request)
      end

      private

      attr_reader :request

      def cancellable?
        CANCELLABLE_REQUESTS.any? { |request_class| request.is_a?(request_class) }
      end
    end
  end
end
