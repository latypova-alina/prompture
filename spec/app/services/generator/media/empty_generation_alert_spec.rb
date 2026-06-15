require "rails_helper"

describe Generator::Media::EmptyGenerationAlert do
  subject(:call_service) do
    described_class.call(processor:, button_request_id:)
  end

  let(:button_request_id) { 123 }

  before do
    allow(Generator::Media::Image::EmptyAlertJob)
      .to receive(:perform_async)

    allow(Generator::Media::Video::EmptyAlertJob)
      .to receive(:perform_async)

    allow(Generator::Media::Audio::EmptyAlertJob)
      .to receive(:perform_async)
  end

  describe ".call" do
    context "when processor is an image processor" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it "dispatches image empty alert job" do
        call_service

        expect(Generator::Media::Image::EmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Video::EmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is a video processor" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it "dispatches video empty alert job" do
        call_service

        expect(Generator::Media::Video::EmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::EmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is an audio processor" do
      let(:processor) { Generator::Processors::AUDIO.first }

      it "dispatches audio empty alert job" do
        call_service

        expect(Generator::Media::Audio::EmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::EmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::EmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is unsupported" do
      let(:processor) { "unknown_processor" }

      it "does not enqueue any job" do
        call_service

        expect(Generator::Media::Image::EmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::EmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end
  end
end
