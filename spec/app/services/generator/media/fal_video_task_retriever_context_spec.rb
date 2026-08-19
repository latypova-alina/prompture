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

  context "when fal flags the request for a content policy violation" do
    let(:params) do
      ActionController::Parameters.new(
        processor: "kling_2_1_pro_image_to_video",
        request_id_token: "token123",
        request_id: "task_1",
        status: "ERROR",
        payload: {
          detail: [
            {
              loc: %w[body prompt],
              msg: "The content could not be processed because it contained material flagged by a content checker.",
              type: "content_policy_violation"
            }
          ]
        }
      )
    end

    describe "#error_reason" do
      it "returns content_flagged" do
        expect(context.error_reason).to eq("content_flagged")
      end
    end

    describe "#flagged_message" do
      it "returns fal's flagged message" do
        expect(context.flagged_message).to eq(
          "The content could not be processed because it contained material flagged by a content checker."
        )
      end
    end
  end
end
