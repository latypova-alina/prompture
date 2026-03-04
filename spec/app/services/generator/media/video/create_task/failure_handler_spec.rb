require "rails_helper"

describe Generator::Media::Video::CreateTask::FailureHandler do
  subject(:call_handler) { described_class.call(request) }

  let(:request) { create(:button_video_processing_request, :belonging_to_user) }

  before do
    allow(Billing::Refunder).to receive(:call)
    allow(Generator::Media::Video::ErrorNotifierJob).to receive(:perform_async)
  end

  describe ".call" do
    it "calls Billing::Refunder with correct arguments" do
      expect(Billing::Refunder).to receive(:call).with(
        user: request.user,
        amount: request.cost,
        source: request
      )

      call_handler
    end

    it "enqueues ErrorNotifierJob with request id" do
      expect(Generator::Media::Video::ErrorNotifierJob)
        .to receive(:perform_async)
        .with(request.id)

      call_handler
    end
  end
end
