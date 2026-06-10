require "rails_helper"

describe MediaGenerator::ButtonHandler::ValidateCartoonScriptRequest do
  subject(:result) { described_class.call(command_request:) }

  let(:image_prompt) { create(:image_prompt) }
  let(:script) { create(:script, image_prompt:) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      category: ContentCategory::CARTOON_SCRIPT,
      image_prompt:
    )
  end

  before { script }

  it "succeeds and stores the script on context" do
    expect(result).to be_success
    expect(result.script).to eq(script)
  end

  context "when command request is not cartoon script" do
    let(:command_request) { create(:command_edit_image_request, image_prompt:) }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end

  context "when script is missing" do
    let(:script) { nil }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
