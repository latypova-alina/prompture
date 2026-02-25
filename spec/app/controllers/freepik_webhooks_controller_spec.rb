require "rails_helper"

describe FreepikWebhooksController, type: :request do
  describe "#receive" do
    it "calls MediaGenerator:: with params" do
      expect(MediaGenerator::SendReply).to receive(:call).with(params: kind_of(ActionController::Parameters))

      post "/freepik_webhook", params: { some: "value" }
    end
  end
end
