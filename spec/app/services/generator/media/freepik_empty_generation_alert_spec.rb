require "rails_helper"

describe Generator::Media::FreepikEmptyGenerationAlert do
  subject(:call_service) do
    described_class.call(processor:, button_request_id:)
  end

  let(:button_request_id) { 123 }

  before do
    allow(Generator::Media::Prompt::FreepikEmptyAlertJob)
      .to receive(:perform_async)

    allow(Generator::Media::Image::FreepikEmptyAlertJob)
      .to receive(:perform_async)

    allow(Generator::Media::Video::FreepikEmptyAlertJob)
      .to receive(:perform_async)
  end

  describe ".call" do
    context "when processor is extend_prompt" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }

      it "dispatches prompt freepik empty alert job" do
        call_service

        expect(Generator::Media::Prompt::FreepikEmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is an image processor" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it "dispatches image freepik empty alert job" do
        call_service

        expect(Generator::Media::Image::FreepikEmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Video::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is a video processor" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it "dispatches video freepik empty alert job" do
        call_service

        expect(Generator::Media::Video::FreepikEmptyAlertJob)
          .to have_received(:perform_async)
          .with(button_request_id)

        expect(Generator::Media::Image::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is unsupported" do
      let(:processor) { "unknown_processor" }

      it "does not enqueue any job" do
        call_service

        expect(Generator::Media::Image::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Prompt::FreepikEmptyAlertJob)
          .not_to have_received(:perform_async)
      end
    end
  end
end
