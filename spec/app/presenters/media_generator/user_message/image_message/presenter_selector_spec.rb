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

    context "when request belongs to edit_image command" do
      let(:command_request) { create(:command_edit_image_request) }
      let(:request) { create(:user_picture_message, command_request:, parent_request: command_request) }

      it "returns EditImagePromptRequestPresenter" do
        presenter = described_class.new(request:).presenter

        expect(presenter).to be_a(
          MediaGenerator::UserMessage::ImageMessage::EditImagePromptRequestPresenter
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

    context "when request belongs to first_last_frame_to_video command" do
      let(:user) { create(:user, :with_balance) }
      let(:command_request) { create(:command_two_frame_to_video_request, user:) }
      let(:request) do
        create(
          :user_picture_message,
          command_request:,
          parent_request: command_request
        )
      end
      let(:two_frames_selector) do
        instance_double(
          MediaGenerator::UserMessage::ImageMessage::ForTwoFramesCommand::PresenterSelector
        )
      end
      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::UserMessage::ImageMessage::ForTwoFramesCommand::PresenterSelector)
          .to receive(:new)
          .with(request:)
          .and_return(two_frames_selector)
        allow(two_frames_selector).to receive(:presenter).and_return(presenter_instance)
      end

      it "delegates to ForTwoFramesCommand::PresenterSelector" do
        expect(described_class.new(request:).presenter).to eq(presenter_instance)
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
