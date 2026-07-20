class ContentCategory
  MOTIVATION = "motivation".freeze
  RANDOM_CHARACTER = "random_character".freeze
  BRAINROT_CHARACTER = "brainrot_character".freeze
  CARTOON_CHARACTER = "cartoon_character".freeze
  BLOOMY_CARTOON_SCRIPT = "bloomy_cartoon_script".freeze
  CARTOON_BLOOMY_SHORTS_SCRIPT = "cartoon_bloomy_shorts_script".freeze
  CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT = "cartoon_bloomy_shorts_complex_script".freeze
  TEMPLATE = "template".freeze

  DEFAULT_IMAGE_BUCKET_FOLDER = "images".freeze

  IMAGE_BUCKET_FOLDERS = {
    BLOOMY_CARTOON_SCRIPT => "cartoon/bloomy/images",
    CARTOON_BLOOMY_SHORTS_SCRIPT => "cartoon/bloomy/shorts/images",
    CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT => "cartoon/bloomy/shorts/images"
  }.freeze

  VIDEO_BUCKET_FOLDERS = {
    BLOOMY_CARTOON_SCRIPT => "cartoon/bloomyvideos",
    CARTOON_BLOOMY_SHORTS_SCRIPT => "cartoon/bloomy/shorts/videos",
    CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT => "cartoon/bloomyshorts/videos",
    MOTIVATION => "videos/motivation"
  }.freeze

  AUDIO_BUCKET_FOLDERS = {
    BLOOMY_CARTOON_SCRIPT => "cartoon/bloomyaudio",
    CARTOON_BLOOMY_SHORTS_SCRIPT => "cartoon/bloomy/shorts/audio",
    CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT => "cartoon/bloomyshorts/audio"
  }.freeze

  MERGED_VIDEO_BUCKET_FOLDERS = {
    BLOOMY_CARTOON_SCRIPT => "cartoon/bloomyvideos/with_audio",
    CARTOON_BLOOMY_SHORTS_SCRIPT => "cartoon/bloomy/shorts/videos/with_audio",
    CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT => "cartoon/bloomyshorts/videos/with_audio"
  }.freeze

  CATEGORY_FORMAT = /\A[a-z0-9_]+\z/

  class << self
    def store_video?(category)
      category.present? && store_video_categories.include?(category)
    end

    def image_bucket_folder(category)
      IMAGE_BUCKET_FOLDERS.fetch(category.to_s, DEFAULT_IMAGE_BUCKET_FOLDER)
    end

    def video_bucket_folder(category)
      VIDEO_BUCKET_FOLDERS[category.to_s]
    end

    def audio_bucket_folder(category)
      AUDIO_BUCKET_FOLDERS.fetch(category.to_s, "audio")
    end

    def merged_video_bucket_folder(category)
      MERGED_VIDEO_BUCKET_FOLDERS.fetch(category.to_s, "videos/with_audio")
    end

    def normalize(value)
      value.to_s.parameterize(separator: "_").presence
    end

    private

    def store_video_categories
      STORAGE_CONFIG.fetch(:store_video_categories).map(&:to_s)
    end
  end
end
