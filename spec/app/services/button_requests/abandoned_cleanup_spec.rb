require "rails_helper"

describe ButtonRequests::AbandonedCleanup do
  subject { described_class.call(now:) }

  let(:now) { Time.zone.parse("2026-10-07 12:00") }
  let!(:abandoned) { create(:button_image_processing_request, status: "PENDING", created_at: now - 2.hours) }
  let!(:charged) { create(:button_image_processing_request, status: "PENDING", created_at: now - 2.hours) }

  before do
    create(:balance_transaction, source: charged, user: charged.user)
    subject
  end

  it { is_expected.to include("ButtonImageProcessingRequest" => 1) }
  it { expect(abandoned.reload).to have_attributes(status: "FAILED", failure_reason: "abandoned_before_charge") }
  it { expect(charged.reload).to have_attributes(status: "PENDING", failure_reason: nil) }
end
