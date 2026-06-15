require "rails_helper"

describe GeneratorWebhooksController, type: :request do
  describe "#receive" do
    it "calls MediaGenerator::SendReply with params" do
      expect(MediaGenerator::SendReply).to receive(:call).with(params: kind_of(ActionController::Parameters))

      post "/api/fal/webhook", params: { some: "value" }
    end
  end
end
