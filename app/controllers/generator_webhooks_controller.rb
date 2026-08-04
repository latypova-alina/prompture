class GeneratorWebhooksController < ApplicationController
  include Memery

  skip_before_action :verify_authenticity_token
  before_action :authenticate_fal_webhook!

  def receive
    MediaGenerator::SendReply.call(params:)
  end

  private

  def authenticate_fal_webhook!
    head :unauthorized unless verifier.valid?
  end

  memoize def verifier
    Fal::WebhookVerifier.new(headers: request.headers, body: request.raw_post)
  end
end
