module Generator
  module Media
    module CreateTask
      class FailureHandlerBase
        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def call
          ::Billing::Refunder.call(user:, amount: cost, source: request)

          error_notifier_job_class.perform_async(request.id)
        end

        private

        delegate :user, :cost, to: :request

        def error_notifier_job_class
          raise NotImplementedError
        end
      end
    end
  end
end
