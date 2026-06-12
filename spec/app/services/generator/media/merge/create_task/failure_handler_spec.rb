require "rails_helper"

describe Generator::Media::Merge::CreateTask::FailureHandler do
  subject(:call_handler) { described_class.call(request) }

  let(:request) { create(:button_merge_audio_video_processing_request) }

  before do
    allow(Billing::Refunder).to receive(:call)
    allow(Generator::Media::Merge::ErrorNotifierJob).to receive(:perform_async)
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
      expect(Generator::Media::Merge::ErrorNotifierJob)
        .to receive(:perform_async)
        .with(request.id)

      call_handler
    end

    context "when error is daily limit exceeded" do
      subject(:call_handler) { described_class.call(request, error:) }

      let(:error) { Freepik::DailyLimitExceeded.new }

      it "enqueues ErrorNotifierJob with daily limit reason" do
        expect(Generator::Media::Merge::ErrorNotifierJob)
          .to receive(:perform_async)
          .with(request.id, "daily_limit_exceeded")

        call_handler
      end
    end
  end
end
