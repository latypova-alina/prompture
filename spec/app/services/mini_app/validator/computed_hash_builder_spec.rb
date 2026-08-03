require "rails_helper"

describe MiniApp::Validator::ComputedHashBuilder do
  subject(:computed_hash) { described_class.new(params:).computed_hash }

  let(:bot_token) { "test-bot-token" }
  let(:params) { { "auth_date" => "1700000000", "query_id" => "abc123" } }

  let(:expected_hash) do
    data_check_string = params.sort.map { |key, value| "#{key}=#{value}" }.join("\n")
    secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", bot_token)
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)
  end

  before do
    stub_const("ENV", ENV.to_hash.merge("TELEGRAM_BOT_TOKEN" => bot_token))
  end

  describe "#computed_hash" do
    it { is_expected.to eq(expected_hash) }

    context "when params includes a hash field" do
      it "excludes the hash field from the data check string" do
        with_hash = described_class.new(params: params.merge("hash" => "irrelevant")).computed_hash

        expect(with_hash).to eq(computed_hash)
      end
    end
  end
end
