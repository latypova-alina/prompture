require "rails_helper"

RSpec.describe Audio::VoiceSampleUrls do
  def sample_key(slug)
    "audio/samples/#{slug}.mp3"
  end

  before do
    all_keys = %w[adam victoria knox milo hope lulu_lollipop].map { |slug| sample_key(slug) }
    allow(S3::ObjectKeysFetcher).to receive(:new).and_return(
      instance_double(S3::ObjectKeysFetcher, object_keys: all_keys)
    )
  end

  describe ".url_for" do
    it "builds a public URL for the voice sample object key" do
      stub_const("ENV", ENV.to_hash.merge("INTERNAL_BUCKET_BASE_URL" => "https://bucket.example"))

      expect(described_class.url_for(:adam)).to eq("https://bucket.example/audio/samples/adam.mp3")
    end
  end

  describe ".samples" do
    it "returns a sample entry for each configured voice with an uploaded file" do
      expect(described_class.samples.map { |sample| sample[:slug] })
        .to eq(%w[adam victoria knox milo hope lulu_lollipop])
    end

    context "when a voice sample file is missing" do
      before do
        available = %w[adam victoria knox milo hope].map { |slug| sample_key(slug) }
        allow(S3::ObjectKeysFetcher).to receive(:new).and_return(
          instance_double(S3::ObjectKeysFetcher, object_keys: available)
        )
      end

      it "excludes that voice" do
        expect(described_class.samples.map { |sample| sample[:slug] })
          .to eq(%w[adam victoria knox milo hope])
      end
    end
  end
end
