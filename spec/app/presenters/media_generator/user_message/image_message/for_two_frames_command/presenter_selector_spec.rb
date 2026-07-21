require "rails_helper"

describe MediaGenerator::UserMessage::ImageMessage::ForTwoFramesCommand::PresenterSelector do
  subject(:selector) { described_class.new(request:) }

  let(:user) { create(:user, :with_balance) }
  let(:command_request) { create(:command_two_frame_to_video_request, user:) }
  let(:request) do
    create(
      :user_picture_message,
      command_request:,
      parent_request: command_request
    )
  end

  context "when no start frame is set" do
    before do
      create(:stored_image, source_message: request, image_url: "https://example.com/start.png")
    end

    it "assigns the start image and returns StartFramePresenter" do
      presenter = selector.presenter

      expect(presenter).to be_a(
        MediaGenerator::UserMessage::ImageMessage::ForTwoFramesCommand::StartFramePresenter
      )
      expect(command_request.reload.start_image_url).to eq("https://example.com/start.png")
    end
  end

  context "when start frame is already set" do
    before do
      command_request.update!(start_image_url: "https://example.com/start.png")
      create(:stored_image, source_message: request, image_url: "https://example.com/end.png")
    end

    it "assigns the end image and returns ReadyFramePresenter" do
      presenter = selector.presenter

      expect(presenter).to be_a(
        MediaGenerator::UserMessage::ImageMessage::ForTwoFramesCommand::ReadyFramePresenter
      )
      expect(command_request.reload.end_image_url).to eq("https://example.com/end.png")
    end
  end
end
