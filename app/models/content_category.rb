class ContentCategory
  MOTIVATION = "motivation".freeze
  RANDOM_CHARACTER = "random_character".freeze
  BRAINROT_CHARACTER = "brainrot_character".freeze
  CARTOON_CHARACTER = "cartoon_character".freeze
  CARTOON_SCRIPT = "cartoon_script".freeze
  TEMPLATE = "template".freeze

  DEFAULT_IMAGE_BUCKET_FOLDER = "images".freeze

  IMAGE_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/images"
  }.freeze

  VIDEO_BUCKET_FOLDERS = {
    CARTOON_SCRIPT => "cartoon/videos",
    MOTIVATION => "videos/motivation"
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

    def normalize(value)
      value.to_s.parameterize(separator: "_").presence
    end

    private

    def store_video_categories
      STORAGE_CONFIG.fetch(:store_video_categories).map(&:to_s)
    end
  end
end
