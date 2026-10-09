module Generator
  module Media
    module CreateTask
      class FailureHandlerBase
        include Memery

        ERROR_REASONS = {
          Generator::DailyLimitExceeded => "daily_limit_exceeded"
        }.freeze

        def self.call(...)
          new(...).call
        end

        def initialize(request, error: nil)
          @request = request
          @error = error
        end

        def call
          report_error
          record_failure

          ::Billing::Refunder.call(user:, amount: cost, source: request)

          error_notifier_job_class.perform_async(*error_notifier_args)
        end

        private

        delegate :user, :cost, to: :request
        delegate :reason, :message, to: :failure_details, prefix: :failure

        attr_reader :request, :error

        def error_reason
          return if error.blank?

          ERROR_REASONS[error.class]
        end

        def record_failure
          return if error.blank?

          ButtonRequests::FailureRecorder.call(
            button_request: request, reason: failure_reason, message: failure_message
          )
        end

        memoize def failure_details
          Generator::Media::CreateTask::FailureDetails.new(error)
        end

        def report_error
          return if error.blank? || error.is_a?(Generator::DailyLimitExceeded)

          Sentry.capture_message(error.message, level: sentry_level)
        end

        def sentry_level
          error.is_a?(Generator::AccessForbidden) ? :fatal : :error
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
