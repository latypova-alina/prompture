require "rails_helper"

describe MiniApp::InitDataValidator do
  subject(:validator) { described_class.new(init_data:) }

  let(:bot_token) { "test-bot-token" }
  let(:user_payload) { { id: 110_542_578, first_name: "Alina" }.to_json }
  let(:signed_params) { { "auth_date" => "1700000000", "user" => user_payload, "query_id" => "abc123" } }

  let(:valid_hash) do
    data_check_string = signed_params.sort.map { |key, value| "#{key}=#{value}" }.join("\n")
    secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", bot_token)
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)
  end

  let(:init_data) { URI.encode_www_form(signed_params.merge("hash" => valid_hash)) }

  before do
    stub_const("ENV", ENV.to_hash.merge("TELEGRAM_BOT_TOKEN" => bot_token))
  end

  describe "#valid?" do
    it { is_expected.to be_valid }

    context "when the hash is tampered with" do
      let(:init_data) { URI.encode_www_form(signed_params.merge("hash" => "deadbeef")) }

      it { is_expected.not_to be_valid }
    end

    context "when the hash is missing" do
      let(:init_data) { URI.encode_www_form(signed_params) }

      it { is_expected.not_to be_valid }
    end

    context "when init_data is blank" do
      let(:init_data) { "" }

      it { is_expected.not_to be_valid }
    end
  end
end
