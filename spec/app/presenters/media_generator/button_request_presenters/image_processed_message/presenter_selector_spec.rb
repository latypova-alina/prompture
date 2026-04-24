require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector do
  describe "#presenter" do
    let(:image_url) { "http://example.com/image.png" }
    let(:locale) { :ru }
    let(:balance) { 4 }
    let(:processor_name) { "Mystic image" }
    let(:processor) { "mystic_image" }
    let(:context) do
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::Context.new(
        image_url:,
        command_request_classname:,
        locale:,
        balance:,
        processor_name:,
        processor:
      )
    end

    context "when command request is prompt to image" do
      let(:command_request_classname) { "CommandPromptToImageRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToImage)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToImage presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end

    context "when command request is prompt to video" do
      let(:command_request_classname) { "CommandPromptToVideoRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToVideo presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end
  end
end
