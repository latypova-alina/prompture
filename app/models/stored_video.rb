class StoredVideo < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :video_url, presence: true
  validates :category, format: { with: ContentCategory::CATEGORY_FORMAT }, allow_nil: true
  validates :source_id, uniqueness: { scope: :source_type }
end
