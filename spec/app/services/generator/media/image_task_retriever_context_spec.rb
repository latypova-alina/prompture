require "rails_helper"

describe Generator::Media::ImageTaskRetrieverContext do
  subject(:context) { described_class.new(params:) }

  let(:decoded_id) { 123 }

  let(:params) do
    ActionController::Parameters.new(
      processor: "flux_image",
      request_id_token: "token123",
      request_id: "task_1",
      status: callback_status,
      payload: {
        images: [
          { url: "https://fal.media/result.jpg" }
        ]
      }
    )
  end

  let(:callback_status) { "OK" }

  before do
    allow(RequestIdToken)
      .to receive(:decode)
      .with("token123")
      .and_return(decoded_id)
  end

  describe "#task_id" do
    it "returns request_id from callback body" do
      expect(context.task_id).to eq("task_1")
    end
  end

  describe "#status" do
    context "when callback status is OK" do
      it "returns COMPLETED" do
        expect(context.status).to eq("COMPLETED")
      end
    end

    context "when callback status indicates failure" do
      let(:callback_status) { "ERROR" }

      it "returns FAILED" do
        expect(context.status).to eq("FAILED")
      end
    end
  end

  describe "#generated" do
    it "returns the result image url" do
      expect(context.generated).to eq(["https://fal.media/result.jpg"])
    end
  end
end
