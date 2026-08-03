require "rails_helper"

describe MiniApp::Validator::ProvidedHashReader do
  subject(:provided_hash) { described_class.new(params:).provided_hash }

  let(:params) { { "auth_date" => "1700000000", "hash" => "abc123" } }

  describe "#provided_hash" do
    it { is_expected.to eq("abc123") }

    context "when the hash is missing" do
      let(:params) { { "auth_date" => "1700000000" } }

      it { is_expected.to be_nil }
    end
  end
end
