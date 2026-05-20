module Generator
  module Media
    module Audio
      class TaskCreatorJob < Generator::Media::TaskCreatorBaseJob
        private

        def task_creator_class
          CreateTask::TaskCreator
        end

        def failure_handler_class
          CreateTask::FailureHandler
        end

        def request_class
          ButtonAudioProcessingRequest
        end
      end
    end
  end
end
