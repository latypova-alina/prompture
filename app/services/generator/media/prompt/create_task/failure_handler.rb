module Generator
  module Media
    module Prompt
      module CreateTask
        class FailureHandler < Generator::Media::CreateTask::FailureHandlerBase
          private

          def error_notifier_job_class
            Generator::Media::Prompt::ErrorNotifierJob
          end
        end
      end
    end
  end
end
