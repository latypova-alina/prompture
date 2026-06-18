module MediaGenerator
  class SendReply
    include Interactor
    include Memery

    delegate :params, to: :context

    def call
      return if status == "IN_PROGRESS"

      delete_interim_message

      if status == "COMPLETED"
        handle_completed_status
      elsif status == "CANCELLED"
        handle_cancelled_status
      elsif status == "FAILED"
        Generator::Media::ErrorNotifierDispatcher.call(processor:, button_request_id:)
      end
    end

    private

    delegate :processor, :status, :button_request_id, :task_id, :generated, to: :task_retriever_context

    memoize def task_retriever_context
      Generator::Media::TaskRetrieverContext.for(params:)
    end

    def delete_interim_message
      Generator::Media::Interim::WebhookMessageDeleter.call(
        processor:,
        button_request_id:
      )
    end

    def handle_completed_status
      Generator::Media::CompletedGenerationDispatcher.call(
        processor:,
        button_request_id:,
        generated:,
        task_id:
      )
    end

    def handle_cancelled_status
      Generator::Media::CancelledGenerationDispatcher.call(processor:, button_request_id:)
    end
  end
end
