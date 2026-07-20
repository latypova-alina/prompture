require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForBloomy::ForShortComplexScript do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 8 }
  let(:processor_name) { "NanoBanana edit" }
  let(:processor) { "nano_banana_edit_image" }

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it "returns an empty keyboard" do
      is_expected.to eq([])
    end
  end
end
