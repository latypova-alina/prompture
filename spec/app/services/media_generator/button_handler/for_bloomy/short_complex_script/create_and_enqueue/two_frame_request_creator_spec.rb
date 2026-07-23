require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateAndEnqueue::TwoFrameRequestCreator do
  subject(:result) do
    described_class.new(start_scene:, end_scene:, command_request:).two_frame_request
  end

  let(:user) { create(:user, :with_balance) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
    )
  end
  let(:script) { create(:script, chained_references: true) }
  let(:start_prompt) { create(:image_prompt) }
  let(:end_prompt) { create(:image_prompt) }
  let(:start_scene) { create(:scene, script:, order: 1, image_prompt: start_prompt) }
  let(:end_scene) { create(:scene, script:, order: 2, image_prompt: end_prompt) }

  before do
    create(
      :stored_image,
      image_prompt: start_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/start.png"
    )
    create(
      :stored_image,
      image_prompt: end_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/end.png"
    )
  end

  it "creates a two-frame request from consecutive scene images" do
    expect { result }.to change(CommandTwoFrameToVideoRequest, :count).by(1)
    expect(result.start_image_url).to eq("https://example.com/start.png")
    expect(result.end_image_url).to eq("https://example.com/end.png")
  end

  context "when a scene image is missing" do
    before { StoredImage.where(image_prompt: start_prompt).delete_all }

    it "raises ImageNotReadyError" do
      expect { result }.to raise_error(ImageNotReadyError)
    end
  end
end
