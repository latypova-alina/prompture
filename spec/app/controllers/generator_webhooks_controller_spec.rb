require "rails_helper"

describe GeneratorWebhooksController, type: :request do
  describe "#receive" do
    subject(:make_request) do
      post "/api/fal/webhook", params: raw_body, headers: signed_headers.merge("Content-Type" => "application/json")
    end

    let(:signing_key) { OpenSSL::PKey.generate_key("ED25519") }
    let(:public_key) { OpenSSL::PKey.new_raw_public_key("ED25519", signing_key.raw_public_key) }

    let(:request_id) { "req_1" }
    let(:user_id) { "user_1" }
    let(:timestamp) { Time.now.to_i.to_s }
    let(:signed_raw_body) { { status: "OK" }.to_json }
    let(:raw_body) { signed_raw_body }

    let(:message) { Fal::Webhook::SignedMessage.new(request_id:, user_id:, timestamp:, body: signed_raw_body).to_s }
    let(:signature) { signing_key.sign(nil, message).unpack1("H*") }

    let(:signed_headers) do
      {
        "X-Fal-Webhook-Request-Id" => request_id,
        "X-Fal-Webhook-User-Id" => user_id,
        "X-Fal-Webhook-Timestamp" => timestamp,
        "X-Fal-Webhook-Signature" => signature
      }
    end

    before do
      allow(Fal::Webhook::PublicKeys).to receive(:fetch).and_return([public_key])
      allow(MediaGenerator::SendReply).to receive(:call)
    end

    context "when the signature is valid" do
      it "calls MediaGenerator::SendReply with params" do
        make_request

        expect(MediaGenerator::SendReply).to have_received(:call).with(params: kind_of(ActionController::Parameters))
      end
    end

    context "when the signature headers are missing" do
      let(:signed_headers) { {} }

      it "returns unauthorized" do
        make_request

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not process the webhook" do
        make_request

        expect(MediaGenerator::SendReply).not_to have_received(:call)
      end
    end

    context "when the signature does not match the body" do
      let(:raw_body) { { status: "FAILED" }.to_json }

      it "returns unauthorized" do
        make_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
