require "rails_helper"

describe Admin::RequestHydration do
  subject(:call) { described_class.call(refs) }

  let(:user) { create(:user, :with_balance) }
  let(:command_request) { create(:command_prompt_to_image_request, user:, created_at: 2.days.ago) }
  let(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, parent_request: command_request,
                                                         created_at: 1.day.ago)
  end

  let(:refs) do
    [
      Admin::RequestRef.new(CommandPromptToImageRequest, command_request.id, command_request.created_at),
      Admin::RequestRef.new(ButtonImageProcessingRequest, button_request.id, button_request.created_at)
    ]
  end

  it "hydrates each ref into its real record, most recent first" do
    expect(call).to eq([button_request, command_request])
  end

  it "eager-loads the user on command requests" do
    hydrated = call.find { |record| record.is_a?(CommandPromptToImageRequest) }

    expect(hydrated.association(:user)).to be_loaded
  end

  it "eager-loads the user (via command_request) on button requests" do
    hydrated = call.find { |record| record.is_a?(ButtonImageProcessingRequest) }

    expect(hydrated.association(:command_request)).to be_loaded
    expect(hydrated.command_request.association(:user)).to be_loaded
  end
end
