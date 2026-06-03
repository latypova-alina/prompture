require "rails_helper"

describe Generator::Media::FalVideoTaskRetrieverContext do
  subject(:context) { described_class.new(params:) }

  let(:params) do
    ActionController::Parameters.new(
      processor: "kling_2_1_pro_image_to_video",
      request_id_token: "token123",
      request_id: "task_1",
      status: callback_status,
      payload: {
        video: {
          url: "https://fal.media/result.mp4"
        }
      }
    )
  end

  let(:callback_status) { "OK" }

  before do
    allow(RequestIdToken)
      .to receive(:decode)
      .with("token123")
      .and_return(123)
  end

  include_examples "fal task retriever context"

  describe "#generated" do
    it "returns the result video url" do
      expect(context.generated).to eq(["https://fal.media/result.mp4"])
    end

    context "when payload has no video url" do
      let(:params) do
        ActionController::Parameters.new(
          processor: "kling_2_1_pro_image_to_video",
          request_id_token: "token123",
          request_id: "task_1",
          status: "OK",
          payload: {}
        )
      end

      it "returns an empty array" do
        expect(context.generated).to eq([])
      end
    end
  end
end
