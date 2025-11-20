class SendReply
  include Interactor
  include Memery

  delegate :params, to: :context

  def call
    return if status == "IN_PROGRESS"

    if status == "COMPLETED"
      Generator::TaskRetrieverSelectorJob.perform_async(body[:task_id], params[:button_request], chat_id)
    elsif status == "FAILED"
      Generator::ErrorNotifierJob.perform_async(params[:button_request], chat_id)
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
