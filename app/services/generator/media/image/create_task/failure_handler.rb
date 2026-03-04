module Generator
  module Media
    module Image
      module CreateTask
        class FailureHandler < Generator::Media::CreateTask::FailureHandlerBase
          private

          def error_notifier_job_class
            Generator::Media::Image::ErrorNotifierJob
          end
        end
      end
    end
  end
end
