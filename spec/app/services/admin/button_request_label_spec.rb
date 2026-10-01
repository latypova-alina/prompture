require "rails_helper"

describe Admin::ButtonRequestLabel do
  subject { described_class.call(button_request) }

  let(:button_request) { create(:button_merge_audio_video_processing_request) }

  it { is_expected.to eq("Merge audio video processing ##{button_request.id}") }
end
