require "rails_helper"

describe ButtonRequests::AbandonedSelection do
  subject { described_class.call(ButtonImageProcessingRequest, now:) }

  let(:now) { Time.zone.parse("2026-10-07 12:00") }
  let(:old) { now - 2.hours }
  let!(:request) { create(:button_image_processing_request, status:, fal_request_id:, created_at:) }
  let(:status) { "PENDING" }
  let(:fal_request_id) { nil }
  let(:created_at) { old }

  context "when an old pending request was never sent or charged" do
    it { is_expected.to contain_exactly(request) }
  end

  context "when the status is still the lowercase DB default" do
    let(:status) { "pending" }

    it { is_expected.to contain_exactly(request) }
  end

  context "when the request is younger than an hour" do
    let(:created_at) { now - 30.minutes }

    it { is_expected.to be_empty }
  end

  context "when the request was sent to fal" do
    let(:fal_request_id) { "fal-123" }

    it { is_expected.to be_empty }
  end

  context "when the request was charged" do
    before { create(:balance_transaction, source: request, user: request.user) }

    it { is_expected.to be_empty }
  end

  context "when the request isn't pending" do
    let(:status) { "COMPLETED" }

    it { is_expected.to be_empty }
  end

  context "when the type has no fal_request_id column" do
    subject { described_class.call(ButtonExtendPromptRequest, now:) }

    let!(:extend_prompt) { create(:button_extend_prompt_request, status: "PENDING", created_at: old) }

    it { is_expected.to contain_exactly(extend_prompt) }
  end
end
