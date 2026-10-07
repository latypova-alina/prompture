require "rails_helper"

describe MediaGenerator::ButtonHandler::DecrementBalance do
  subject { described_class.call(chat_id: 456, button_request_record:, command_request:) }

  let(:command_request) { button_request_record.command_request }

  describe "#call" do
    context "when cost is zero" do
      let(:button_request_record) { create(:button_image_processing_request) }

      before { allow(button_request_record).to receive(:cost).and_return(0) }

      it "does not call Billing::Charger" do
        expect(Billing::Charger).not_to receive(:call)

        expect(subject).to be_success
      end
    end

    context "when cost is positive" do
      let(:button_request_record) { create(:button_image_processing_request) }

      before { allow(Billing::Charger).to receive(:call) }

      it "calls Billing::Charger with correct arguments" do
        expect(Billing::Charger).to receive(:call).with(
          user: command_request.user,
          amount: button_request_record.cost,
          source: button_request_record
        )

        subject
      end

      context "and InsufficientCreditsError is raised" do
        before do
          allow(Billing::Charger).to receive(:call)
            .and_raise(InsufficientCreditsError)
        end

        it "fails the context with error class" do
          result = subject

          expect(result).to be_failure
          expect(result.error).to eq(InsufficientCreditsError)
        end
      end
    end
  end

  describe "with a real balance" do
    let(:user) { create(:user, :with_custom_balance, credits:) }
    let(:button_request_record) { create(:button_image_processing_request, user:) }
    let(:insufficient_credits_failure) { { status: "FAILED", failure_reason: "insufficient_credits" } }

    before { subject }

    context "when the user can't afford the request" do
      let(:credits) { 0 }

      it { is_expected.to be_failure }
      it { expect(subject.error).to eq(InsufficientCreditsError) }
      it { expect(button_request_record.reload).to have_attributes(insufficient_credits_failure) }
    end

    context "when the user can afford the request" do
      let(:credits) { 100 }

      it { is_expected.to be_success }
      it { expect(button_request_record.reload).to have_attributes(status: "PENDING", failure_reason: nil) }
    end
  end
end
