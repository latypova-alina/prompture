require "rails_helper"

describe ContentCategory do
  describe ".normalize" do
    it "parameterizes values for storage" do
      expect(described_class.normalize("My Template")).to eq("my_template")
    end
  end

  describe ".image_bucket_folder" do
    it "returns bloomy cartoon image folder for bloomy cartoon script" do
      expect(described_class.image_bucket_folder(ContentCategory::BLOOMY_CARTOON_SCRIPT))
        .to eq("cartoon/bloomy/images")
    end

    it "returns bloomy shorts image folder for bloomy shorts script" do
      expect(described_class.image_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT))
        .to eq("cartoon/bloomy/shorts/images")
    end

    it "returns bloomy shorts image folder for complex bloomy shorts script" do
      expect(described_class.image_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT))
        .to eq("cartoon/bloomy/shorts/images")
    end

    it "returns images for other categories" do
      expect(described_class.image_bucket_folder(ContentCategory::MOTIVATION))
        .to eq("images")
    end
  end

  describe ".video_bucket_folder" do
    it "returns bloomy cartoon video folder for bloomy cartoon script" do
      expect(described_class.video_bucket_folder(ContentCategory::BLOOMY_CARTOON_SCRIPT))
        .to eq("cartoon/bloomy/videos")
    end

    it "returns bloomy shorts video folder for bloomy shorts script" do
      expect(described_class.video_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT))
        .to eq("cartoon/bloomy/shorts/videos")
    end

    it "returns bloomy shorts video folder for complex bloomy shorts script" do
      expect(described_class.video_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT))
        .to eq("cartoon/bloomy/shorts/videos")
    end

    it "returns videos/motivation for motivation" do
      expect(described_class.video_bucket_folder(ContentCategory::MOTIVATION))
        .to eq("videos/motivation")
    end

    it "returns videos for other categories" do
      expect(described_class.video_bucket_folder(ContentCategory::RANDOM_CHARACTER))
        .to eq("videos")
    end

    it "returns videos when category is nil" do
      expect(described_class.video_bucket_folder(nil)).to eq("videos")
    end
  end

  describe ".audio_bucket_folder" do
    it "returns bloomy cartoon audio folder for bloomy cartoon script" do
      expect(described_class.audio_bucket_folder(ContentCategory::BLOOMY_CARTOON_SCRIPT))
        .to eq("cartoon/bloomy/audio")
    end

    it "returns bloomy shorts audio folder for bloomy shorts script" do
      expect(described_class.audio_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT))
        .to eq("cartoon/bloomy/shorts/audio")
    end

    it "returns bloomy shorts audio folder for complex bloomy shorts script" do
      expect(described_class.audio_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT))
        .to eq("cartoon/bloomy/shorts/audio")
    end

    it "returns audio for other categories" do
      expect(described_class.audio_bucket_folder(ContentCategory::MOTIVATION)).to eq("audio")
    end
  end

  describe ".merged_video_bucket_folder" do
    it "returns bloomy cartoon merged video folder for bloomy cartoon script" do
      expect(described_class.merged_video_bucket_folder(ContentCategory::BLOOMY_CARTOON_SCRIPT))
        .to eq("cartoon/bloomy/videos/with_audio")
    end

    it "returns bloomy shorts merged video folder for bloomy shorts script" do
      expect(described_class.merged_video_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT))
        .to eq("cartoon/bloomy/shorts/videos/with_audio")
    end

    it "returns bloomy shorts merged video folder for complex bloomy shorts script" do
      expect(described_class.merged_video_bucket_folder(ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT))
        .to eq("cartoon/bloomy/shorts/videos/with_audio")
    end

    it "returns videos/with_audio for other categories" do
      expect(described_class.merged_video_bucket_folder(ContentCategory::MOTIVATION))
        .to eq("videos/with_audio")
    end
  end
end
