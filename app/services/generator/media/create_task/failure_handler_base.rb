module Generator
  module Media
    module CreateTask
      class FailureHandlerBase
        ERROR_REASONS = {
          Generator::DailyLimitExceeded => "daily_limit_exceeded"
        }.freeze

        BALANCE_EXHAUSTED_SIGNAL = "Exhausted balance".freeze

        def self.call(...)
          new(...).call
        end

        def initialize(request, error: nil)
          @request = request
          @error = error
        end

        def call
          report_balance_exhaustion if balance_exhausted?

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

        def balance_exhausted?
          error.is_a?(Generator::ResponseError) && error.message.include?(BALANCE_EXHAUSTED_SIGNAL)
        end

        def report_balance_exhaustion
          Sentry.capture_message(
            "fal.ai balance exhausted — generation is failing for all users. Top up at fal.ai/dashboard/billing.",
            level: :fatal
          )
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
