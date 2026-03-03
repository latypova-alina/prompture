module MediaGenerator
  class SendReply
    include Interactor
    include Memery

    delegate :params, to: :context

    def call
      return if status == "IN_PROGRESS"

      if status == "COMPLETED"
        Generator::Image::TaskRetrieverJob.perform_async(task_id, button_request_id, processor)
      elsif status == "FAILED"
        Generator::ErrorNotifierDispatcher.call(processor:, button_request_id:)
      end
    end

    private

    delegate :processor, :status, :button_request_id, :task_id, to: :task_retriever_context

    memoize def task_retriever_context
      Generator::TaskRetrieverContext.new(params:)
    end
  end
end
