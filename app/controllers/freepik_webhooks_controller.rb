class FreepikWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    body = params.require(:freepik_webhook).permit!

    return if body[:status] == "IN_PROGRESS"

    if body[:status] == "COMPLETED"
      chat_id = ChatToken.decode(params[:token])

      Generator::TaskRetrieverSelectorJob.perform_async(body[:task_id], params[:button_request], chat_id)
    elsif body[:status] == "FAILED"
      Generator::Image::ErrorNotifierJob.perform_async(chat_id)
    end
  end
end
