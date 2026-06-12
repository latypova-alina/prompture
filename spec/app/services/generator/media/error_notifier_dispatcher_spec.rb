require "rails_helper"

describe Generator::Media::ErrorNotifierDispatcher do
  subject(:call_service) do
    described_class.call(processor:, button_request_id:)
  end

  let(:button_request_id) { 123 }

  before do
    allow(Generator::Media::Prompt::ErrorNotifierJob)
      .to receive(:perform_async)

    allow(Generator::Media::Image::ErrorNotifierJob)
      .to receive(:perform_async)

    allow(Generator::Media::Video::ErrorNotifierJob)
      .to receive(:perform_async)

    allow(Generator::Media::Audio::ErrorNotifierJob)
      .to receive(:perform_async)

    allow(Generator::Media::Merge::ErrorNotifierJob)
      .to receive(:perform_async)
  end

  describe ".call" do
    context "when processor is extend_prompt" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }

      it "dispatches prompt error notifier job" do
        call_service

        expect(Generator::Media::Prompt::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is an image processor" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it "dispatches image error notifier job" do
        call_service

        expect(Generator::Media::Image::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Video::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is a video processor" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it "dispatches video error notifier job" do
        call_service

        expect(Generator::Media::Video::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is an audio processor" do
      let(:processor) { Generator::Processors::AUDIO.first }

      it "dispatches audio error notifier job" do
        call_service

        expect(Generator::Media::Audio::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is a merge processor" do
      let(:processor) { Generator::Processors::MERGE.first }

      it "dispatches merge error notifier job" do
        call_service

        expect(Generator::Media::Merge::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Video::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Audio::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is unsupported" do
      let(:processor) { "unknown_processor" }

      it "does not enqueue any job" do
        call_service

        expect(Generator::Media::Image::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::ErrorNotifierJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end
  end
end
