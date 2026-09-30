require "rails_helper"

describe Admin::ButtonRequestEagerLoad do
  subject(:call) { described_class.call(klass) }

  context "when the type has a media association" do
    let(:klass) { ButtonImageProcessingRequest }

    it "includes the media association" do
      expect(call.includes_values).to include(:stored_image)
    end

    it "includes command_request and user" do
      expect(call.includes_values).to include(command_request: :user)
    end
  end

  context "when the type has no media association" do
    let(:klass) { ButtonExtendPromptRequest }

    it "only includes command_request and user" do
      expect(call.includes_values).to contain_exactly(command_request: :user)
    end
  end
end
