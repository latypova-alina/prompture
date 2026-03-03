module Generator
  module Media
    module Image
      class TaskRetrieverJob < ApplicationJob
        include Memery

        def perform(task_id, button_request_id, processor)
          @task_id = task_id
          @processor = processor

          SuccessNotifierJob.perform_async(media_url, button_request_id)
        rescue Freepik::ResponseError
          ErrorNotifierJob.perform_async(button_request_id)
        end

        private

        attr_reader :task_id, :processor

        delegate :media_url, to: :task_retriever

        memoize def task_retriever
          Image::RetrieveTask::TaskRetriever.new(task_id, processor)
        end
      end
    end
  end
end
