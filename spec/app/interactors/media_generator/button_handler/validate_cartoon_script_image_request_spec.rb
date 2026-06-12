require "rails_helper"

describe MediaGenerator::ButtonHandler::ValidateCartoonScriptImageRequest do
  subject(:result) { described_class.call(command_request:) }

  let(:image_prompt) { create(:image_prompt) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      category: ContentCategory::CARTOON_SCRIPT,
      image_prompt:
    )
  end

  it "succeeds" do
    expect(result).to be_success
  end

  context "when command request is not cartoon script" do
    let(:command_request) { create(:command_edit_image_request, image_prompt:) }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
