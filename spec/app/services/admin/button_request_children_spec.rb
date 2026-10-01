require "rails_helper"

describe Admin::ButtonRequestChildren do
  subject { described_class.call(button_request) }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, parent_request: command_request)
  end

  let!(:video_child) do
    create(:button_video_processing_request, command_request:, parent_request: button_request, created_at: 1.day.ago)
  end
  let!(:image_child) do
    create(:button_image_processing_request, command_request:, parent_request: button_request,
                                             created_at: 2.days.ago)
  end

  before { create(:button_image_processing_request, command_request:, parent_request: command_request) }

  it { is_expected.to eq([image_child, video_child]) }
end
