module Generator
  module Image
    class FailureHandler
      def self.call(...)
        new(...).call
      end

      def initialize(request)
        @request = request
      end

      def call
        ::Billing::Refunder.call(user:, amount: cost, source: request)

        Generator::Image::ErrorNotifierJob.perform_async(request.id)
      end

      private

      delegate :user, :cost, to: :request
    end
  end
end
