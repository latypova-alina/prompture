require "rails_helper"

describe PublicBaseUrl do
  subject(:resolved) { described_class.resolve }

  describe ".resolve" do
    context "when not in production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
        stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
      end

      it { is_expected.to eq("http://localhost:3000") }
    end

    context "when in production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
        stub_const("ENV", ENV.to_hash.merge("PRODUCTION_BASE_URL" => "https://app.example.com"))
      end

      it { is_expected.to eq("https://app.example.com") }
    end
  end
end
