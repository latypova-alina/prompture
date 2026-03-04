module Generator
  module Media
    module Video
      class TaskCreatorJob < Generator::Media::TaskCreatorBaseJob
        private

        def task_creator_class
          CreateTask::TaskCreator
        end

        def failure_handler_class
          CreateTask::FailureHandler
        end

        def request_class
          ButtonVideoProcessingRequest
        end
      end
    end
  end
end
