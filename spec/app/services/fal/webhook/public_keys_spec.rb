require "rails_helper"

describe Fal::Webhook::PublicKeys do
  subject(:fetch_keys) { described_class.fetch }

  let(:signing_key) { OpenSSL::PKey.generate_key("ED25519") }
  let(:encoded_x) { Base64.urlsafe_encode64(signing_key.raw_public_key, padding: false) }
  let(:response) do
    instance_double(Faraday::Response, success?: true, status: 200, body: { keys: [{ x: encoded_x }] }.to_json)
  end

  around do |example|
    original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    example.run
    Rails.cache = original_cache
  end

  before do
    allow(Faraday).to receive(:get).and_return(response)
  end

  it "returns ED25519 public keys decoded from the JWKS response" do
    expect(fetch_keys.first.raw_public_key).to eq(signing_key.raw_public_key)
  end

  it "caches the JWKS response instead of fetching it on every call" do
    fetch_keys
    fetch_keys

    expect(Faraday).to have_received(:get).once
  end

  context "when the JWKS request fails" do
    let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: "") }

    it "raises a descriptive error" do
      expect { fetch_keys }.to raise_error("Fal JWKS fetch failed: 500")
    end
  end
end
