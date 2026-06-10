require "rails_helper"

describe ScriptGenerator::ProcessScript::ForEditImage do
  subject(:service) { described_class.new(chat_id:, category:, reference_image_url:) }

  let(:chat_id) { 456 }
  let(:category) { ContentCategory::CARTOON_SCRIPT }
  let(:script) { "Bloomy waves at the camera." }
  let!(:user) { create(:user, :with_balance, chat_id:) }
  let(:reference_image_url) { "https://example.com/bloomy.png" }

  before do
    allow(ScriptGenerator::ProcessScript::StartEditImageGeneration).to receive(:call)
  end

  describe "#call" do
    it "creates an edit image request with prompt and category" do
      expect { service.call(script:) }.to change(CommandEditImageRequest, :count).by(1)

      command_request = CommandEditImageRequest.last
      expect(command_request).to have_attributes(
        chat_id:,
        user:,
        category:,
        prompt: script
      )
    end

    it "attaches the character reference image" do
      expect { service.call(script:) }.to change(UserImageUrlMessage, :count).by(1)

      image_message = UserImageUrlMessage.last
      expect(image_message).to have_attributes(
        image_url: reference_image_url,
        command_request: CommandEditImageRequest.last,
        parent_request: CommandEditImageRequest.last
      )
    end

    it "starts edit image generation" do
      service.call(script:)

      expect(ScriptGenerator::ProcessScript::StartEditImageGeneration)
        .to have_received(:call)
        .with(command_request: CommandEditImageRequest.last)
    end

    it "creates a separate edit image request for each script" do
      service.call(script: "scene one")
      service.call(script: "scene two")

      expect(CommandEditImageRequest.pluck(:prompt)).to contain_exactly("scene one", "scene two")
    end
  end
end
