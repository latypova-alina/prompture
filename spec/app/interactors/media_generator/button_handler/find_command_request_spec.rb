require "rails_helper"

describe MediaGenerator::ButtonHandler::FindCommandRequest do
  subject { described_class.call(parent_request:) }

  let(:command_request) { create(:command_prompt_to_image_request) }

  context "when parent_request is a command request" do
    let(:parent_request) { command_request }

    it "assigns parent_request as command_request" do
      result = subject

      expect(result).to be_success
      expect(result.command_request).to eq(parent_request)
    end
  end

  context "when parent_request is not a command request" do
    let(:parent_request) { create(:button_extend_prompt_request, command_request:, parent_request: command_request) }

    it "assigns command_request from parent_request" do
      result = subject

      expect(result).to be_success
      expect(result.command_request).to eq(command_request)
    end
  end
end
