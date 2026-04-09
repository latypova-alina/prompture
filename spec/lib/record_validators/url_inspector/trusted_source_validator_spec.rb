require "rails_helper"

RSpec.describe RecordValidators::UrlInspector::TrustedSourceValidator do
  describe "#valid?" do
    subject(:valid?) { described_class.new(uri: uri).valid? }

    context "when uri is nil" do
      let(:uri) { nil }

      it { is_expected.to be(false) }
    end

    context "when uri has unsupported scheme" do
      let(:uri) { URI.parse("ftp://cdn-magnific.freepik.com/image.jpg") }

      it { is_expected.to be(false) }
    end

    context "when host is trusted" do
      let(:uri) { URI.parse("https://CDN-MAGNIFIC.FREEPIK.COM/image.jpg") }

      it { is_expected.to be(true) }
    end

    context "when host is trusted ai statics" do
      let(:uri) { URI.parse("https://ai-statics.freepik.com/path/image.png?token=abc") }

      it { is_expected.to be(true) }
    end

    context "when host is freepik root domain" do
      let(:uri) { URI.parse("https://freepik.com/image.jpg") }

      it { is_expected.to be(false) }
    end

    context "when host is not trusted" do
      let(:uri) { URI.parse("https://example.com/image.jpg") }

      it { is_expected.to be(false) }
    end
  end
end
