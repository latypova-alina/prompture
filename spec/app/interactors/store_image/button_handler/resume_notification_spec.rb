require "rails_helper"

describe StoreImage::ButtonHandler::ResumeNotification do
  subject(:call) { described_class.call(record_type:, record_id:) }

  let(:record_type) { "UserImageUrlMessage" }
  let(:record_id) { "406" }

  before do
    allow(StoreImage::SuccessNotifierJob).to receive(:perform_async)
  end

  it "re-enqueues the success notifier job for the same record" do
    call

    expect(StoreImage::SuccessNotifierJob).to have_received(:perform_async).with(record_type, record_id)
  end
end
