require "rails_helper"

RSpec.describe RecordValidators::UrlInspector::SimpleImageUrlValidator do
  describe "#valid?" do
    subject(:valid?) { described_class.new(uri: uri).valid? }

    context "when uri is http and has allowed extension" do
      let(:uri) { URI.parse("http://example.com/image.jpg") }

      it { is_expected.to be(true) }
    end

    context "when uri is https and extension is uppercase" do
      let(:uri) { URI.parse("https://example.com/image.PNG") }

      it { is_expected.to be(true) }
    end

    context "when extension is not allowed" do
      let(:uri) { URI.parse("https://example.com/image.gif") }

      it { is_expected.to be(false) }
    end

    context "when scheme is unsupported" do
      let(:uri) { URI.parse("ftp://example.com/image.jpg") }

      it { is_expected.to be(false) }
    end
  end
end
