module Generator
  module Media
    module Video
      module CreateTask
        class FailureHandler < Generator::Media::CreateTask::FailureHandlerBase
          private

          def error_notifier_job_class
            Generator::Video::ErrorNotifierJob
          end
        end
      end
    end
  end
end
