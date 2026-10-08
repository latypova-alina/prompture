module Generator
  module Media
    module CreateTask
      # Why submitting a task to fal failed, as the button request's failure_reason / failure_message.
      class FailureDetails
        include Memery

        CONTENT_FLAGGED = "content_flagged".freeze
        UNKNOWN = "task_creation_error".freeze
        REASONS = {
          Generator::DailyLimitExceeded => "daily_limit_exceeded",
          Generator::AccessForbidden => "access_forbidden",
          Generator::ResponseError => "response_error"
        }.freeze

        def initialize(error)
          @error = error
        end

        def reason
          return CONTENT_FLAGGED if fal_error_detail.content_policy_violation?

          REASONS.fetch(error.class, UNKNOWN)
        end

        # The fal response body (or the error message when there's no body).
        def message
          error.message
        end

        private

        attr_reader :error

        memoize def fal_error_detail
          Generator::Media::FalErrorDetail.new(parsed_body)
        end

        def parsed_body
          body = JSON.parse(error.message)
          body.is_a?(Hash) ? body : {}
        rescue JSON::ParserError
          {}
        end
      end
    end
  end
end
