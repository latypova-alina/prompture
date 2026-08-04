require "rails_helper"

describe Fal::Webhook::HeaderReader do
  subject(:reader) { described_class.new(headers:) }

  let(:headers) do
    {
      "X-Fal-Webhook-Request-Id" => "req_1",
      "X-Fal-Webhook-User-Id" => "user_1",
      "X-Fal-Webhook-Timestamp" => "1700000000",
      "X-Fal-Webhook-Signature" => "abc123"
    }
  end

  describe "#request_id" do
    subject { reader.request_id }

    it { is_expected.to eq("req_1") }
  end

  describe "#user_id" do
    subject { reader.user_id }

    it { is_expected.to eq("user_1") }
  end

  describe "#timestamp" do
    subject { reader.timestamp }

    it { is_expected.to eq("1700000000") }
  end

  describe "#signature" do
    subject { reader.signature }

    it { is_expected.to eq("abc123") }
  end

  describe "#present?" do
    subject { reader.present? }

    it { is_expected.to be(true) }

    context "when a header is missing" do
      let(:headers) { super().except("X-Fal-Webhook-Signature") }

      it { is_expected.to be(false) }
    end
  end
end
