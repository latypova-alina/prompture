module MediaGenerator
  class SendReply
    include Interactor
    include Memery

    delegate :params, to: :context

    def call
      return if status == "IN_PROGRESS"

      if status == "COMPLETED"
        handle_completed_status
      elsif status == "FAILED"
        Generator::Media::ErrorNotifierDispatcher.call(processor:, button_request_id:)
      end
    end

    private

    delegate :processor, :status, :button_request_id, :task_id, :generated, to: :task_retriever_context

    memoize def task_retriever_context
      Generator::Media::TaskRetrieverContext.new(params:)
    end

    def handle_completed_status
      if generated.empty?
        Generator::Media::FreepikEmptyGenerationAlert.call(processor:, button_request_id:)
      else
        Generator::Media::TaskRetrieverDispatcher.call(task_id:, button_request_id:, processor:)
      end
    end
  end
end
