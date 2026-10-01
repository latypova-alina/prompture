require "rails_helper"

describe Admin::HasButtonRequestsFilter do
  subject(:call) do
    described_class.new(value).apply(CommandPromptToImageRequest.where(user:), CommandPromptToImageRequest)
  end

  let(:user) { create(:user, :with_balance) }
  let!(:with_button) { create(:command_prompt_to_image_request, user:) }
  let!(:without_button) { create(:command_prompt_to_image_request, user:) }

  before { create(:button_image_processing_request, :completed, command_request: with_button) }

  context "when value is nil" do
    let(:value) { nil }

    it "does not filter anything" do
      expect(call).to contain_exactly(with_button, without_button)
    end
  end

  context "when value is 'with'" do
    let(:value) { "with" }

    it { is_expected.to contain_exactly(with_button) }
  end

  context "when value is 'without'" do
    let(:value) { "without" }

    it { is_expected.to contain_exactly(without_button) }
  end

  context "when the command's only button request is an extend prompt request" do
    subject do
      described_class.new(value).apply(CommandPromptToAudioRequest.where(user:), CommandPromptToAudioRequest)
    end

    let!(:extended_command) { create(:command_prompt_to_audio_request, user:) }
    let!(:bare_command) { create(:command_prompt_to_audio_request, user:) }

    before { create(:button_extend_prompt_request, command_request: extended_command) }

    context "when value is 'with'" do
      let(:value) { "with" }

      it { is_expected.to contain_exactly(extended_command) }
    end

    context "when value is 'without'" do
      let(:value) { "without" }

      it { is_expected.to contain_exactly(bare_command) }
    end
  end

  context "when a button request with the same id belongs to a different command type" do
    subject do
      described_class.new("with").apply(CommandPromptToVideoRequest.where(id: video_command.id),
                                        CommandPromptToVideoRequest)
    end

    let(:video_command) { create(:command_prompt_to_video_request, user:, id: with_button.id) }

    it { is_expected.to be_empty }
  end
end
