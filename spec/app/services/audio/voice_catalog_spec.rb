require "rails_helper"

RSpec.describe Audio::VoiceCatalog do
  describe ".slugs" do
    it "returns configured voice slugs for the default processor" do
      expect(described_class.slugs).to eq(%i[adam victoria knox_dark milo hope])
    end
  end

  describe ".voice_id" do
    it "returns the ElevenLabs voice id for a slug" do
      expect(described_class.voice_id(slug: :adam)).to eq("hIssydxXZ1WuDorjx6Ic")
      expect(described_class.voice_id(slug: :knox_dark)).to eq("dPah2VEoifKnZT37774q")
    end
  end

  describe ".valid_slug?" do
    it "returns true for known slugs" do
      expect(described_class.valid_slug?(slug: :hope)).to be(true)
    end

    it "returns false for unknown slugs" do
      expect(described_class.valid_slug?(slug: :unknown)).to be(false)
    end
  end
end
