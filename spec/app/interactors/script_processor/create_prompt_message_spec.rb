require "rails_helper"

describe ScriptProcessor::CreatePromptMessage do
  subject(:result) { described_class.call(script:, command_request:, subcategory:) }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:script) { "A scenic mountain shot at sunrise." }
  let(:subcategory) { nil }

  it "creates prompt_message linked to command_request" do
    expect { result }.to change(PromptMessage, :count).by(1)

    prompt_message = result.prompt_message
    expect(prompt_message.prompt).to eq(script)
    expect(prompt_message.command_request).to eq(command_request)
    expect(prompt_message.parent_request).to eq(command_request)
    expect(prompt_message.subcategory).to be_nil
  end

  context "when subcategory is provided" do
    let(:subcategory) { "cry" }

    it "persists subcategory on prompt_message" do
      expect(result.prompt_message.subcategory).to eq("cry")
    end
  end
end
