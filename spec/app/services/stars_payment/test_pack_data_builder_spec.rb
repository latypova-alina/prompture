require "rails_helper"

describe StarsPayment::TestPackDataBuilder do
  subject(:pack_data) { described_class.new(locale:).pack_data }

  let(:locale) { "en" }
  let(:invoice_url) { "https://t.me/$test" }

  before do
    allow(StarsPayment::InvoiceBuilder).to receive(:new).and_return(double(invoice_url:))
  end

  describe "#pack_data" do
    it "returns a pack for each configured test pack" do
      expect(pack_data.map { |p| p[:key] }).to match_array(TEST_CREDIT_PACKS.keys)
    end

    it "prices every pack at 1 star" do
      expect(pack_data).to all(include(stars: 1))
    end

    it "keeps the same credit amounts as the real packs" do
      medium_pack = pack_data.find { |p| p[:key] == :medium }

      expect(medium_pack[:credits]).to eq(CREDIT_PACKS[:medium][:credits])
    end
  end
end
