require "rails_helper"

describe Generator::Media::Image::SuccessNotifierJob do
  subject(:perform_job) do
    described_class.new.perform(image_url, button_request_id)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:button_request_id) { 123 }

  before do
    allow(
      Generator::Media::Image::NotifySuccess::SuccessNotifier
    ).to receive(:call)
  end

  it "calls SuccessNotifier with correct arguments" do
    expect(
      Generator::Media::Image::NotifySuccess::SuccessNotifier
    ).to receive(:call).with(image_url:, button_request_id:)

    perform_job
  end
end
