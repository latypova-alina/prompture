class FreepikWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    response_body = JSON.parse(request.body.read)
    chat_id = ChatToken.decode(params[:token])
    image_url = response_body.dig("data", "generated")[0]

    Telegram.bot.send_photo(chat_id: chat_id, photo: image_url)
  end
end
