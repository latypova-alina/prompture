require "rails_helper"

describe ScriptGenerator::ProcessScript::ForEditImage do
  subject(:service) { described_class.new(chat_id:, category:, reference_image_url:) }

  let(:chat_id) { 456 }
  let(:category) { ContentCategory::CARTOON_SCRIPT }
  let(:image_prompt) { create(:image_prompt, prompt: "Bloomy waves at the camera.") }
  let!(:user) { create(:user, :with_balance, chat_id:) }
  let(:reference_image_url) { "https://example.com/bloomy.png" }

  before do
    allow(ScriptGenerator::ProcessScript::StartEditImageGeneration).to receive(:call)
  end

  describe "#call" do
    it "creates an edit image request with category" do
      expect { service.call }.to change(CommandEditImageRequest, :count).by(1)

      command_request = CommandEditImageRequest.last
      expect(command_request).to have_attributes(
        chat_id:,
        user:,
        category:,
        image_prompt: nil
      )
    end

    it "links the edit image request to the image prompt when provided" do
      service.call(image_prompt_record: image_prompt)

      command_request = CommandEditImageRequest.last
      expect(command_request.image_prompt).to eq(image_prompt)
      expect(command_request.prompt).to eq(image_prompt.prompt)
    end

    it "attaches the character reference image" do
      service.call(image_prompt_record: image_prompt)

      image_message = UserImageUrlMessage.last
      expect(image_message).to have_attributes(
        image_url: reference_image_url,
        command_request: CommandEditImageRequest.last,
        parent_request: CommandEditImageRequest.last
      )
    end

    it "starts edit image generation" do
      service.call(image_prompt_record: image_prompt)

      expect(ScriptGenerator::ProcessScript::StartEditImageGeneration)
        .to have_received(:call)
        .with(command_request: CommandEditImageRequest.last)
    end

    it "creates a separate edit image request for each image prompt" do
      first_prompt = create(:image_prompt, prompt: "scene one")
      second_prompt = create(:image_prompt, prompt: "scene two")

      service.call(image_prompt_record: first_prompt)
      service.call(image_prompt_record: second_prompt)

      expect(CommandEditImageRequest.all.map(&:prompt)).to contain_exactly("scene one", "scene two")
    end
  end
end
