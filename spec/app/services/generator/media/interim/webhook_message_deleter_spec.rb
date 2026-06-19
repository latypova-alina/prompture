require "rails_helper"

describe Generator::Media::Interim::WebhookMessageDeleter do
  subject(:call_deleter) do
    described_class.call(
      processor:,
      button_request_id: request.id
    )
  end

  let(:request) do
    create(:button_video_processing_request, interim_tg_message_id: 12_345)
  end

  before do
    allow(Generator::Media::Interim::MessageDeleter).to receive(:call)
  end

  context "when processor uses interim messages" do
    let(:processor) { "kling_2_1_pro_image_to_video" }

    it "delegates to MessageDeleter with loaded request" do
      call_deleter

      expect(Generator::Media::Interim::MessageDeleter)
        .to have_received(:call)
        .with(request: request)
    end
  end

  context "when processor does not use interim messages" do
    let(:processor) { "elevenlabs_v3_audio" }

    it "does not call MessageDeleter" do
      call_deleter

      expect(Generator::Media::Interim::MessageDeleter).not_to have_received(:call)
    end
  end
end
