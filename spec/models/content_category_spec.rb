require "rails_helper"

describe ContentCategory do
  describe ".store_video?" do
    it "returns true for allowlisted categories" do
      expect(described_class.store_video?("motivation")).to be(true)
      expect(described_class.store_video?(ContentCategory::CARTOON_SCRIPT)).to be(true)
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

  describe ".image_bucket_folder" do
    it "returns cartoon/images for cartoon script" do
      expect(described_class.image_bucket_folder(ContentCategory::CARTOON_SCRIPT))
        .to eq("cartoon/images")
    end

    it "returns images for other categories" do
      expect(described_class.image_bucket_folder(ContentCategory::MOTIVATION))
        .to eq("images")
    end
  end

  describe ".video_bucket_folder" do
    it "returns cartoon/videos for cartoon script" do
      expect(described_class.video_bucket_folder(ContentCategory::CARTOON_SCRIPT))
        .to eq("cartoon/videos")
    end

    it "returns videos/motivation for motivation" do
      expect(described_class.video_bucket_folder(ContentCategory::MOTIVATION))
        .to eq("videos/motivation")
    end
  end
end
