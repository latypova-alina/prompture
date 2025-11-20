require "rails_helper"

describe FreepikWebhooksController, type: :request do
  describe "#receive" do
    it "calls SendReply with params" do
      expect(SendReply).to receive(:call).with(params: kind_of(ActionController::Parameters))

      post "/freepik/webhook", params: { some: "value" }
    end
  end
end
