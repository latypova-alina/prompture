require "rails_helper"

describe Generator::Media::Video::CreateTask::FailureHandler do
  subject(:call_handler) { described_class.call(request) }

  let(:request) { create(:button_video_processing_request) }

  before do
    allow(Billing::Refunder).to receive(:call)
    allow(Generator::Media::Video::ErrorNotifierJob).to receive(:perform_async)
    allow(Sentry).to receive(:capture_message)
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

    context "when error is daily limit exceeded" do
      subject(:call_handler) { described_class.call(request, error:) }

      let(:error) { Generator::DailyLimitExceeded.new }

      it "enqueues ErrorNotifierJob with daily limit reason" do
        expect(Generator::Media::Video::ErrorNotifierJob)
          .to receive(:perform_async)
          .with(request.id, "daily_limit_exceeded")

        call_handler
      end

      it "does not report to Sentry" do
        call_handler

        expect(Sentry).not_to have_received(:capture_message)
      end
    end

    context "when fal.ai returns 403 Forbidden" do
      subject(:call_handler) { described_class.call(request, error:) }

      let(:error) { Generator::AccessForbidden.new('{"detail":"User is locked. Reason: Exhausted balance."}') }

      it "reports the error message to Sentry at fatal level" do
        call_handler

        expect(Sentry)
          .to have_received(:capture_message)
          .with(error.message, level: :fatal)
      end
    end

    context "when the request fails with a non-403 error" do
      subject(:call_handler) { described_class.call(request, error:) }

      let(:error) { Generator::ResponseError.new('{"detail":"Internal server error"}') }

      it "reports the error message to Sentry at error level" do
        call_handler

        expect(Sentry)
          .to have_received(:capture_message)
          .with(error.message, level: :error)
      end
    end
  end
end
