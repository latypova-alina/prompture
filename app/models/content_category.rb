class ContentCategory
  MOTIVATION = "motivation".freeze
  RANDOM_CHARACTER = "random_character".freeze
  BRAINROT_CHARACTER = "brainrot_character".freeze
  CARTOON_CHARACTER = "cartoon_character".freeze
  CARTOON_SCRIPT = "cartoon_script".freeze
  CARTOON_SHORTS_SCRIPT = "cartoon_shorts_script".freeze
  TEMPLATE = "template".freeze

  DEFAULT_IMAGE_BUCKET_FOLDER = "images".freeze

  IMAGE_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/images",
    CARTOON_SHORTS_SCRIPT => "cartoon/shorts/images"
  }.freeze

  VIDEO_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/videos",
    CARTOON_SHORTS_SCRIPT => "cartoon/shorts/videos",
    MOTIVATION => "videos/motivation"
  }.freeze

  AUDIO_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/audio",
    CARTOON_SHORTS_SCRIPT => "cartoon/shorts/audio"
  }.freeze

  MERGED_VIDEO_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/videos/with_audio",
    CARTOON_SHORTS_SCRIPT => "cartoon/shorts/videos/with_audio"
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
