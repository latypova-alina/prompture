require "rails_helper"

RSpec.describe Audio::VoiceSampleUrls do
  describe ".url_for" do
    it "builds a public URL for the voice sample object key" do
      stub_const("ENV", ENV.to_hash.merge("INTERNAL_BUCKET_BASE_URL" => "https://bucket.example"))

      expect(described_class.url_for(:adam)).to eq("https://bucket.example/audio/samples/adam.mp3")
    end
  end

  describe ".samples" do
    it "returns a sample entry for each configured voice" do
      expect(described_class.samples.map { |sample| sample[:slug] })
        .to eq(%w[adam victoria knox milo hope lulu_lollipop])
    end
  end
end
