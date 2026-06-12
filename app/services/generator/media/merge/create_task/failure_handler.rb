module Generator
  module Media
    module Merge
      module CreateTask
        class FailureHandler < Generator::Media::CreateTask::FailureHandlerBase
          private

          def error_notifier_job_class
            Generator::Media::Merge::ErrorNotifierJob
          end
        end
      end
    end
  end
end
