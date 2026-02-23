class SendReply
  include Interactor
  include Memery

  delegate :params, to: :context

  def call
    return if status == "IN_PROGRESS"

    if status == "COMPLETED"
      Generator::TaskRetrieverDispatcher.call(
        task_id: body[:task_id],
        button_request: params[:button_request],
        request_id: params[:request_id],
        chat_id:
      )

    elsif status == "FAILED"
      Generator::ErrorNotifierDispatcher.call(button_request: params[:button_request], chat_id:)
    end
  end

  private

  memoize def body
    params.require(:freepik_webhook).permit!
  end

  memoize def status
    body[:status]
  end

  memoize def chat_id
    ChatToken.decode(params[:token])
  end
end
