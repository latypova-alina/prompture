require "rails_helper"

describe MediaGenerator::UserMessage::ImageMessage::PresenterSelector do
  describe "#presenter" do
    context "when request is ImageUrlMessage" do
      let(:request) { build(:image_url_message, image_url: "https://example.com/image.png") }

      it "returns ImageUrlMessagePresenter" do
        presenter = described_class.new(request:).presenter

        expect(presenter).to be_a(
          MediaGenerator::UserMessage::ImageMessage::ImageUrlMessagePresenter
        )
      end
    end

    context "when request is PictureMessage" do
      let(:request) { build(:picture_message) }

      it "returns PictureMessagePresenter" do
        presenter = described_class.new(request:).presenter

        expect(presenter).to be_a(
          MediaGenerator::UserMessage::ImageMessage::PictureMessagePresenter
        )
      end
    end
  end
end
