require "rails_helper"

describe Generator::Media::Audio::CreateTask::FailureHandler do
  subject(:call_handler) { described_class.call(request, error:) }

  let(:request) { create(:button_audio_processing_request) }
  let(:error) { nil }

  before do
    allow(Billing::Refunder).to receive(:call)
    allow(Generator::Media::Audio::ErrorNotifierJob).to receive(:perform_async)
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
      expect(Generator::Media::Audio::ErrorNotifierJob)
        .to receive(:perform_async)
        .with(request.id)

      call_handler
    end

    it "does not report to Sentry" do
      call_handler

      expect(Sentry).not_to have_received(:capture_message)
    end

    context "when fal.ai returns 403 Forbidden" do
      let(:error) { Generator::AccessForbidden.new('{"detail":"User is locked. Reason: Exhausted balance."}') }

      it "reports the error message to Sentry at fatal level" do
        call_handler

        expect(Sentry)
          .to have_received(:capture_message)
          .with(error.message, level: :fatal)
      end
    end

    context "when the request fails with a 422 or other non-403 error" do
      let(:error) { Generator::ResponseError.new('{"detail":"content_policy_violation"}') }

      it "reports the error message to Sentry at error level" do
        call_handler

        expect(Sentry)
          .to have_received(:capture_message)
          .with(error.message, level: :error)
      end

      it "still refunds and notifies the user the same as any other failure" do
        call_handler

        expect(Billing::Refunder).to have_received(:call).with(
          user: request.user,
          amount: request.cost,
          source: request
        )
        expect(Generator::Media::Audio::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(request.id)
      end
    end

    context "when error is daily limit exceeded" do
      let(:error) { Generator::DailyLimitExceeded.new }

      it "enqueues ErrorNotifierJob with daily limit reason" do
        expect(Generator::Media::Audio::ErrorNotifierJob)
          .to receive(:perform_async)
          .with(request.id, "daily_limit_exceeded")

        call_handler
      end

      it "does not report to Sentry" do
        call_handler

        expect(Sentry).not_to have_received(:capture_message)
      end
    end
  end
end
