require "rails_helper"

describe Generator::Media::Merge::SuccessNotifierJob do
  subject(:perform_job) do
    described_class.new.perform(video_url, button_request_id)
  end

  let(:video_url) { "http://example.com/merged-video.mp4" }
  let(:button_request_id) { 123 }

  before do
    allow(Generator::Media::Merge::NotifySuccess::SuccessNotifier).to receive(:call)
  end

  it "calls SuccessNotifier with correct arguments" do
    expect(Generator::Media::Merge::NotifySuccess::SuccessNotifier)
      .to receive(:call).with(video_url:, button_request_id:)

    perform_job
  end
end
