module Generator
  module Media
    module Video
      class TaskRetrieverJob < Generator::Media::TaskRetrieverBaseJob
        private

        def task_retriever_class
          RetrieveTask::TaskRetriever
        end

        def error_notifier_job_class
          ErrorNotifierJob
        end

        def success_notifier_job_class
          SuccessNotifierJob
        end
      end
    end
  end
end
