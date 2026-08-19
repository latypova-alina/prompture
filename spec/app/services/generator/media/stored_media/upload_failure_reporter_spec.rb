require "rails_helper"

describe Generator::Media::StoredMedia::UploadFailureReporter do
  subject(:report) { described_class.call(error:, button_request_id:, processor:, media_url:) }

  let(:error) { StandardError.new("upload boom") }
  let(:button_request_id) { 42 }
  let(:processor) { "kling_2_1_pro_image_to_video" }
  let(:media_url) { "https://fal.media/source.mp4" }

  before do
    allow(Rails.logger).to receive(:error)
    allow(Sentry).to receive(:capture_exception)
  end

  it "logs the failure" do
    report

    expect(Rails.logger).to have_received(:error).with(a_string_including("upload boom"))
  end

  it "reports the failure to Sentry" do
    report

    expect(Sentry).to have_received(:capture_exception).with(
      error,
      extra: { button_request_id:, processor:, media_url: }
    )
  end
end
