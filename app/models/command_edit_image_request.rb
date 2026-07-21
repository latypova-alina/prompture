class CommandEditImageRequest < ApplicationRecord
  include CartoonScriptCheckable
  include HasLatestImageMessage

  belongs_to :user
  belongs_to :image_prompt, optional: true

  validates :category, format: { with: ContentCategory::CATEGORY_FORMAT }, allow_nil: true

  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy
  has_many :user_picture_messages, as: :command_request, dependent: :destroy
  has_many :user_image_url_messages, as: :command_request, dependent: :destroy
  has_many :user_file_messages, as: :command_request, dependent: :destroy

  def prompt
    super.presence || image_prompt&.prompt
  end
end
