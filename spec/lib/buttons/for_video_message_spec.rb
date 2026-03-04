require "rails_helper"

describe Buttons::ForVideoMessage do
  describe ".build" do
    subject(:result) { described_class.build }

    it "returns an empty array" do
      expect(result).to eq([])
    end

    it "returns an Array" do
      expect(result).to be_an(Array)
    end
  end
end
