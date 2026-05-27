require "rails_helper"

describe Generator::Media::Image::RetrieveTask::ApiUrlFetcher do
  subject(:api_url) { described_class.new(processor).api_url }

  describe "#api_url" do
    context "when processor is gemini_image" do
      let(:processor) { "gemini_image" }

      it "returns gemini api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview")
      end
    end

    context "when processor is mystic_image" do
      let(:processor) { "mystic_image" }

      it "returns mystic api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/mystic")
      end
    end

    context "when processor is imagen_image" do
      let(:processor) { "imagen_image" }

      it "returns imagen api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/text-to-image/imagen3")
      end
    end

    context "when processor is unknown" do
      let(:processor) { "unknown_processor" }

      it "returns nil" do
        expect(api_url).to be_nil
      end
    end
  end
end
