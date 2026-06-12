require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::AudioProcessedMessage::PresenterSelector do
  subject(:selector) do
    described_class.new(
      request:,
      message:,
      balance:,
      processor_name:,
      processor:
    )
  end

  let(:message) { "https://example.com/audio.mp3" }
  let(:balance) { 4 }
  let(:processor_name) { "Lulu Lollipop" }
  let(:processor) { "elevenlabs_v3_audio" }

  describe "#presenter" do
    context "when cartoon script audio has merge prerequisites" do
      let(:command_request) do
        create(:command_prompt_to_audio_request, category: ContentCategory::CARTOON_SCRIPT)
      end
      let(:video_request) do
        create(
          :button_video_processing_request,
          :completed,
          command_request: create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT),
          video_url: "https://example.com/video.mp4"
        )
      end
      let(:audio_prompt) { create(:audio_prompt) }
      let(:request) do
        create(
          :button_audio_processing_request,
          :completed,
          command_request:,
          parent_request: video_request,
          audio_prompt:
        )
      end

      it "returns ForCartoonScript presenter" do
        expect(selector.presenter)
          .to be_a(MediaGenerator::ButtonRequestPresenters::AudioProcessedMessage::ForCartoonScript)
      end
    end

    context "when video url is missing" do
      let(:command_request) do
        create(:command_prompt_to_audio_request, category: ContentCategory::CARTOON_SCRIPT)
      end
      let(:video_request) do
        create(
          :button_video_processing_request,
          command_request: create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT),
          video_url: nil
        )
      end
      let(:request) do
        create(
          :button_audio_processing_request,
          :completed,
          command_request:,
          parent_request: video_request,
          audio_prompt: create(:audio_prompt)
        )
      end

      it "returns default presenter" do
        expect(selector.presenter)
          .to be_a(MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter)
      end
    end

    context "when request is not cartoon script" do
      let(:request) { create(:button_audio_processing_request, :completed) }

      it "returns default presenter" do
        expect(selector.presenter)
          .to be_a(MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter)
      end
    end
  end
end
