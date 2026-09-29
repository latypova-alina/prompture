require "rails_helper"

describe Admin::Page do
  subject(:call) { described_class.call(collection, page:) }

  let(:collection) { (1..45).to_a }

  context "when on the first page" do
    let(:page) { 1 }

    it { expect(call.records).to eq((1..20).to_a) }
    it { expect(call.current_page).to eq(1) }
    it { expect(call.total_pages).to eq(3) }
    it { expect(call.total_count).to eq(45) }
  end

  context "when on the last partial page" do
    let(:page) { 3 }

    it { expect(call.records).to eq((41..45).to_a) }
  end

  context "when the page is beyond the collection" do
    let(:page) { 10 }

    it { expect(call.records).to eq([]) }
  end

  context "when the page is zero or negative" do
    let(:page) { 0 }

    it "clamps to page 1" do
      expect(call.current_page).to eq(1)
    end
  end

  context "when the collection is empty" do
    let(:collection) { [] }
    let(:page) { 1 }

    it { expect(call.records).to eq([]) }
    it { expect(call.total_pages).to eq(1) }
  end
end
