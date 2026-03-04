# spec/services/generator/media/task_retriever_context_spec.rb

require "rails_helper"

describe Generator::Media::TaskRetrieverContext do
  subject(:context) { described_class.new(params) }

  let(:decoded_id) { 123 }

  let(:params) do
    ActionController::Parameters.new(
      processor: "gemini_image",
      request_id_token: "token123",
      freepik_webhook: {
        task_id: "task_1",
        status: "COMPLETED"
      }
    )
  end

  before do
    allow(RequestIdToken)
      .to receive(:decode)
      .with("token123")
      .and_return(decoded_id)
  end

  describe "#task_id" do
    it "returns task_id from webhook body" do
      expect(context.task_id).to eq("task_1")
    end
  end

  describe "#processor" do
    it "returns processor from params" do
      expect(context.processor).to eq("gemini_image")
    end
  end

  describe "#status" do
    it "returns status from webhook body" do
      expect(context.status).to eq("COMPLETED")
    end
  end

  describe "#button_request_id" do
    it "decodes request_id_token" do
      expect(context.button_request_id).to eq(decoded_id)

      expect(RequestIdToken)
        .to have_received(:decode)
        .with("token123")
    end
  end
end
