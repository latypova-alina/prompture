class FreepikWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    MediaGenerator::SendReply.call(params:)
  end
end
