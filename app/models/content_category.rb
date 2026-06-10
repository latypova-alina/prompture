class ContentCategory
  MOTIVATION = "motivation".freeze
  RANDOM_CHARACTER = "random_character".freeze
  BRAINROT_CHARACTER = "brainrot_character".freeze
  CARTOON_CHARACTER = "cartoon_character".freeze
  CARTOON_SCRIPT = "cartoon_script".freeze
  TEMPLATE = "template".freeze

  CATEGORY_FORMAT = /\A[a-z0-9_]+\z/

  class << self
    def store_video?(category)
      category.present? && store_video_categories.include?(category)
    end

    def bucket_folder(category)
      category.to_s
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
