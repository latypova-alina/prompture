require "rails_helper"

describe ScriptGenerator::ForMotivation::MotivationScriptVoice do
  describe ".for" do
    it "returns adam for English" do
      expect(described_class.for(language: "en")).to eq("adam")
    end

    it "returns adam for Polish" do
      expect(described_class.for(language: "pl")).to eq("adam")
    end

    it "returns knox_dark for Russian" do
      expect(described_class.for(language: "ru")).to eq("knox_dark")
    end

    it "defaults to adam when language is blank" do
      expect(described_class.for(language: nil)).to eq("adam")
      expect(described_class.for(language: "")).to eq("adam")
    end
  end
end
