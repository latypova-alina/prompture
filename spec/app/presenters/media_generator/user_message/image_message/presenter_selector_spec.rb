require "rails_helper"

describe MediaGenerator::UserMessage::ImageMessage::PresenterSelector do
  describe "#presenter" do
    context "when request is UserImageUrlMessage" do
      let(:request) { build(:user_image_url_message, image_url: "https://example.com/image.png") }

      it "returns ImageUrlMessagePresenter" do
        presenter = described_class.new(request:).presenter

        expect(presenter).to be_a(
          MediaGenerator::UserMessage::ImageMessage::ImageUrlMessagePresenter
        )
      end
    end

    context "when request is UserPictureMessage" do
      let(:request) { build(:user_picture_message) }

      it "returns PictureMessagePresenter" do
        presenter = described_class.new(request:).presenter

        expect(presenter).to be_a(
          MediaGenerator::UserMessage::ImageMessage::PictureMessagePresenter
        )
      end
    end

    context "when request type is unsupported" do
      let(:request) { build(:prompt_message) }

      it "raises NotImplementedError" do
        expect { described_class.new(request:).presenter }
          .to raise_error(NotImplementedError, /Unsupported request type/)
      end
    end
  end
end
