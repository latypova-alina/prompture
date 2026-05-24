class StoredVideo < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :video_url, :category, :subcategory, presence: true
  validates :category, :subcategory, format: { with: ContentCategory::CATEGORY_FORMAT }
  validates :source_id, uniqueness: { scope: :source_type }
end
