require "rails_helper"

describe MediaGenerator::CommandRequestClassResolver do
  subject(:call) { described_class.new(command:, user:).call }

  let(:user) { create(:user) }

  MediaGenerator::CommandRequestClassResolver::HANDLERS.each do |command_name, klass|
    context "when command is #{command_name}" do
      let(:command) { command_name }

      it { is_expected.to eq(klass) }
    end
  end

  context "when command is unknown" do
    let(:command) { "unknown_command" }

    it { is_expected.to be_nil }
  end

  context "when command is prompt_to_image and the video workflow flag is enabled for the user" do
    let(:command) { "prompt_to_image" }

    before { Flipper.enable(:flipper_prompt_to_image_video_workflow, user) }

    it { is_expected.to eq(CommandPromptToVideoRequest) }
  end

  context "when command is prompt_to_image and the flag is enabled for a different user" do
    let(:command) { "prompt_to_image" }
    let(:other_user) { create(:user) }

    before { Flipper.enable(:flipper_prompt_to_image_video_workflow, other_user) }

    it { is_expected.to eq(CommandPromptToImageRequest) }
  end
end
