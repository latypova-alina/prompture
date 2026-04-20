module Generator
  module Media
    module CreateTask
      class FailureHandlerBase
        ERROR_REASONS = {
          Freepik::DailyLimitExceeded => "daily_limit_exceeded"
        }.freeze

        def self.call(...)
          new(...).call
        end

        def initialize(request, error: nil)
          @request = request
          @error = error
        end

        def call
          ::Billing::Refunder.call(user:, amount: cost, source: request)

          error_notifier_job_class.perform_async(*error_notifier_args)
        end

        private

        delegate :user, :cost, to: :request

        attr_reader :request, :error

        def error_reason
          return if error.blank?

          ERROR_REASONS[error.class]
        end

        def error_notifier_args
          [request.id, error_reason].compact
        end

        def error_notifier_job_class
          raise NotImplementedError
        end
      end
    end
  end
end
