require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector do
  describe "#presenter" do
    let(:image_url) { "http://example.com/image.png" }
    let(:locale) { :ru }
    let(:balance) { 4 }

    context "when command request is prompt to image" do
      subject(:selector) do
        described_class.new(image_url, "CommandPromptToImageRequest", locale, balance)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToImage)
          .to receive(:new)
          .with(message: image_url, locale:, balance:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToImage presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end

    context "when command request is prompt to video" do
      subject(:selector) do
        described_class.new(image_url, "CommandPromptToVideoRequest", locale, balance)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo)
          .to receive(:new)
          .with(message: image_url, locale:, balance:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToVideo presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end
  end
end
