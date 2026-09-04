require "rails_helper"

describe Generator::Media::Image::CreateTask::FailureHandler do
  subject(:call_handler) { described_class.call(request, error:) }

  let(:request) { create(:button_image_processing_request) }
  let(:error) { nil }

  before do
    allow(Billing::Refunder).to receive(:call)
    allow(Generator::Media::Image::ErrorNotifierJob).to receive(:perform_async)
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
      expect(Generator::Media::Image::ErrorNotifierJob)
        .to receive(:perform_async)
        .with(request.id)

      call_handler
    end

    it "does not report to Sentry" do
      call_handler

      expect(Sentry).not_to have_received(:capture_message)
    end

    context "when fal.ai balance is exhausted" do
      let(:error) { Generator::ResponseError.new('{"detail":"User is locked. Reason: Exhausted balance."}') }

      it "reports to Sentry" do
        call_handler

        expect(Sentry)
          .to have_received(:capture_message)
          .with(a_string_including("fal.ai balance exhausted"), level: :fatal)
      end

      it "still refunds and notifies the user the same as any other failure" do
        call_handler

        expect(Billing::Refunder).to have_received(:call).with(
          user: request.user,
          amount: request.cost,
          source: request
        )
        expect(Generator::Media::Image::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(request.id)
      end
    end

    context "when the request fails for an unrelated reason" do
      let(:error) { Generator::ResponseError.new('{"detail":"Internal server error"}') }

      it "does not report to Sentry" do
        call_handler

        expect(Sentry).not_to have_received(:capture_message)
      end
    end
  end
end
