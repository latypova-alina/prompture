module Generator
  module Media
    module Prompt
      class TaskRetrieverJob < Generator::Media::TaskRetrieverBaseJob
        private

        def task_retriever_class
          RetrieveTask::TaskRetriever
        end

        def success_notifier_job_class
          SuccessNotifierJob
        end

        def error_notifier_job_class
          ErrorNotifierJob
        end
      end
    end
  end
end
