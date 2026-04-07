require "rails_helper"
require "ostruct"

RSpec.describe RecordValidators::UrlInspector::FetchableUrlValidator do
  describe "#valid?" do
    subject(:valid?) { described_class.new(url: url).valid? }

    let(:url) { "https://example.com/image.jpg" }

    it "returns true when response is successful" do
      allow(Faraday).to receive(:get).and_return(instance_double(Faraday::Response, success?: true))

      expect(valid?).to be(true)
    end

    it "returns false when response is not successful" do
      allow(Faraday).to receive(:get).and_return(instance_double(Faraday::Response, success?: false))

      expect(valid?).to be(false)
    end

    it "returns false when request raises an error" do
      allow(Faraday).to receive(:get).and_raise(StandardError)

      expect(valid?).to be(false)
    end

    it "configures user-agent and timeouts" do
      request = OpenStruct.new(headers: {}, options: OpenStruct.new)
      allow(Faraday).to receive(:get).and_yield(request).and_return(instance_double(Faraday::Response, success?: true))

      valid?

      expect(request.headers["User-Agent"]).to eq("Mozilla/5.0 (compatible; Prompture/1.0)")
      expect(request.options.timeout).to eq(3)
      expect(request.options.open_timeout).to eq(3)
    end
  end
end
