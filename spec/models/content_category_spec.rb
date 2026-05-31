require "rails_helper"

describe ContentCategory do
  describe ".store_video?" do
    it "returns true for allowlisted categories" do
      expect(described_class.store_video?("motivation")).to be(true)
    end

    it "returns false for unknown categories" do
      expect(described_class.store_video?("random_character")).to be(false)
      expect(described_class.store_video?("brainrot_character")).to be(false)
      expect(described_class.store_video?("cartoon_character")).to be(false)
    end

    it "returns false when category is blank" do
      expect(described_class.store_video?(nil)).to be(false)
    end
  end

  describe ".normalize" do
    it "parameterizes values for storage" do
      expect(described_class.normalize("My Template")).to eq("my_template")
    end
  end
end
