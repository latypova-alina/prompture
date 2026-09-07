require "rails_helper"

describe MiniApp::BuyStones::ValidateInitData do
  subject(:result) { described_class.call(init_data:) }

  let(:bot_token) { "test-bot-token" }
  let(:signed_params) { { "auth_date" => "1700000000", "user" => { id: 1, first_name: "Alina" }.to_json } }

  let(:valid_hash) do
    data_check_string = signed_params.sort.map { |key, value| "#{key}=#{value}" }.join("\n")
    secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", bot_token)
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)
  end

  let(:init_data) { URI.encode_www_form(signed_params.merge("hash" => valid_hash)) }

  before do
    stub_const("ENV", ENV.to_hash.merge("TELEGRAM_BOT_TOKEN" => bot_token))
  end

  describe "#call" do
    context "when init_data is valid" do
      it "returns success" do
        expect(result).to be_success
      end
    end

    context "when init_data is invalid" do
      let(:init_data) { URI.encode_www_form(signed_params.merge("hash" => "deadbeef")) }

      it "fails with MiniApp::InvalidInitDataError" do
        expect(result).to be_failure
        expect(result.error).to eq(MiniApp::InvalidInitDataError)
      end
    end
  end
end
