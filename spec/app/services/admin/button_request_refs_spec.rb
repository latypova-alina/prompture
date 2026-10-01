require "rails_helper"

describe Admin::ButtonRequestRefs do
  subject(:call) { described_class.call(relations) }

  let(:user) { create(:user, :with_balance) }
  let(:image_command) { create(:command_prompt_to_image_request, user:) }

  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: image_command, created_at: 1.day.ago)
  end

  let(:relations) do
    {
      ButtonImageProcessingRequest => ButtonImageProcessingRequest.where(id: image_request.id),
      ButtonExtendPromptRequest => ButtonExtendPromptRequest.where(id: extend_prompt_request.id)
    }
  end

  it "returns refs across relations, most recent first" do
    expect(call.map { |ref| [ref.klass, ref.id] }).to eq(
      [[ButtonExtendPromptRequest, extend_prompt_request.id], [ButtonImageProcessingRequest, image_request.id]]
    )
  end
end
