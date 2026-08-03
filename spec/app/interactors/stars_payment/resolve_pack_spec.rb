require "rails_helper"

describe StarsPayment::ResolvePack do
  subject(:result) { described_class.call(pack_key:) }

  describe "#call" do
    context "when pack exists" do
      let(:pack_key) { "medium" }

      it "assigns the pack to context" do
        expect(result.pack).to eq(CREDIT_PACKS[:medium])
      end

      it "returns success" do
        expect(result).to be_success
      end
    end

    context "when pack does not exist" do
      let(:pack_key) { "unknown" }

      it "fails with PackNotFoundError" do
        expect(result).to be_failure
        expect(result.error).to eq(PackNotFoundError)
      end
    end
  end
end
