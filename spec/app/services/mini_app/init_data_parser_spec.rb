require "rails_helper"

describe MiniApp::InitDataParser do
  subject(:parser) { described_class.new(init_data:) }

  let(:user_payload) { { id: 110_542_578, first_name: "Alina" }.to_json }
  let(:signed_params) { { "auth_date" => "1700000000", "user" => user_payload, "query_id" => "abc123" } }
  let(:init_data) { URI.encode_www_form(signed_params) }

  describe "#user_id" do
    subject(:user_id) { parser.user_id }

    it { is_expected.to eq(110_542_578) }

    context "when the user field is malformed JSON" do
      let(:signed_params) { { "auth_date" => "1700000000", "user" => "not-json" } }

      it { is_expected.to be_nil }
    end
  end

  describe "#user_name" do
    subject(:user_name) { parser.user_name }

    it { is_expected.to eq("Alina") }

    context "when the user field is malformed JSON" do
      let(:signed_params) { { "auth_date" => "1700000000", "user" => "not-json" } }

      it { is_expected.to be_nil }
    end
  end
end
