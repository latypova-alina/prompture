module MediaGenerator
  class SendReply
    include Interactor
    include Memery

    delegate :params, to: :context

    def call
      return if status == "IN_PROGRESS"

      if status == "COMPLETED"
        Generator::TaskRetrieverDispatcher.call(task_retriever_context)
      elsif status == "FAILED"
        Generator::ErrorNotifierDispatcher.call(processor: params[:processor], button_request_id:)
      end
    end

    private

    def task_retriever_context
      Generator::TaskRetrieverContext.new(
        task_id: body[:task_id],
        processor: params[:processor],
        button_request_id:
      )
    end

    memoize def body
      params.require(:freepik_webhook).permit!
    end

    memoize def status
      body[:status]
    end

    memoize def button_request_id
      RequestIdToken.decode(params[:request_id_token])
    end
  end
end
