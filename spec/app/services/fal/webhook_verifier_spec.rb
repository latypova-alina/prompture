require "rails_helper"

describe Fal::WebhookVerifier do
  subject(:verifier) { described_class.new(headers:, body:) }

  let(:signing_key) { OpenSSL::PKey.generate_key("ED25519") }
  let(:public_key) { OpenSSL::PKey.new_raw_public_key("ED25519", signing_key.raw_public_key) }

  let(:request_id) { "req_1" }
  let(:user_id) { "user_1" }
  let(:timestamp) { Time.now.to_i.to_s }
  let(:signed_body) { '{"status":"OK"}' }
  let(:body) { signed_body }

  let(:message) { Fal::Webhook::SignedMessage.new(request_id:, user_id:, timestamp:, body: signed_body).to_s }
  let(:signature) { signing_key.sign(nil, message).unpack1("H*") }

  let(:headers) do
    {
      "X-Fal-Webhook-Request-Id" => request_id,
      "X-Fal-Webhook-User-Id" => user_id,
      "X-Fal-Webhook-Timestamp" => timestamp,
      "X-Fal-Webhook-Signature" => signature
    }
  end

  before do
    allow(Fal::Webhook::PublicKeys).to receive(:fetch).and_return([public_key])
  end

  describe "#valid?" do
    subject { verifier.valid? }

    it { is_expected.to be(true) }

    context "when the body was tampered with after signing" do
      let(:body) { '{"status":"FAILED"}' }

      it { is_expected.to be(false) }
    end

    context "when signed by a key fal does not publish" do
      let(:public_key) { OpenSSL::PKey.new_raw_public_key("ED25519", OpenSSL::PKey.generate_key("ED25519").raw_public_key) }

      it { is_expected.to be(false) }
    end

    context "when the timestamp is older than the allowed clock skew" do
      let(:timestamp) { (Time.now.to_i - 301).to_s }

      it { is_expected.to be(false) }
    end

    context "when a required header is missing" do
      let(:headers) { super().except("X-Fal-Webhook-Signature") }

      it { is_expected.to be(false) }
    end
  end
end
