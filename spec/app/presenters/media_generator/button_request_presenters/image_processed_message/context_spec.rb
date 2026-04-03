require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::Context do
  describe ".new" do
    it "builds context with keyword arguments" do
      context = described_class.new(
        image_url: "https://example.com/image.png",
        command_request_classname: "CommandPromptToImageRequest",
        locale: "ru",
        balance: 7,
        processor_name: "Mystic image"
      )

      expect(context.image_url).to eq("https://example.com/image.png")
      expect(context.command_request_classname).to eq("CommandPromptToImageRequest")
      expect(context.locale).to eq("ru")
      expect(context.balance).to eq(7)
      expect(context.processor_name).to eq("Mystic image")
    end

    it "does not accept positional arguments" do
      expect do
        described_class.new("url", "CommandPromptToImageRequest", "en", 5, "Mystic image")
      end.to raise_error(ArgumentError)
    end
  end
end
