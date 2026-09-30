require "rails_helper"

describe Admin::ButtonRequestScope do
  subject(:call) { described_class.call(klass: ButtonImageProcessingRequest, user:, filters:) }

  let(:filters) { Admin::ButtonRequestsQuery::Filters.new(status:, processor:, command_type:) }
  let(:status) { nil }
  let(:processor) { nil }
  let(:command_type) { nil }

  let(:user) { create(:user, :with_balance) }
  let(:image_command) { create(:command_prompt_to_image_request, user:) }
  let(:audio_command) { create(:command_prompt_to_audio_request, user:) }

  let!(:completed_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, processor: "flux_image")
  end
  let!(:pending_request) do
    create(:button_image_processing_request, command_request: image_command, processor: "nano_banana_image")
  end

  it "scopes to the user's button requests across all command types by default" do
    expect(call).to contain_exactly(completed_request, pending_request)
  end

  it "does not include another user's button requests" do
    other_user = create(:user, :with_balance)
    other_command = create(:command_prompt_to_image_request, user: other_user)
    create(:button_image_processing_request, :completed, command_request: other_command)

    expect(call).to contain_exactly(completed_request, pending_request)
  end

  context "when filtering by status" do
    let(:status) { "COMPLETED" }

    it { is_expected.to contain_exactly(completed_request) }

    context "given a different casing than what's stored" do
      let(:status) { "completed" }

      it "still matches, case-insensitively" do
        expect(call).to contain_exactly(completed_request)
      end
    end
  end

  context "when filtering by processor" do
    let(:processor) { "flux_image" }

    it { is_expected.to contain_exactly(completed_request) }
  end

  context "when filtering by command type" do
    let!(:other_type_request) do
      create(:button_image_processing_request, command_request: create(:command_prompt_to_video_request, user:))
    end

    context "matching the command's own type" do
      let(:command_type) { "CommandPromptToImageRequest" }

      it { is_expected.to contain_exactly(completed_request, pending_request) }
    end

    context "matching a different command type" do
      let(:command_type) { "CommandPromptToVideoRequest" }

      it { is_expected.to contain_exactly(other_type_request) }
    end
  end
end
