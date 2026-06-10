class CommandEditImageRequest < ApplicationRecord
  belongs_to :user
  belongs_to :image_prompt, optional: true

  validates :category, format: { with: ContentCategory::CATEGORY_FORMAT }, allow_nil: true

  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy
  has_many :user_picture_messages, as: :command_request, dependent: :destroy
  has_many :user_image_url_messages, as: :command_request, dependent: :destroy

  def cartoon_script?
    category == ContentCategory::CARTOON_SCRIPT
  end

  def self.cartoon_script_edit_image?(command_request: nil, classname: nil, category: nil)
    if command_request.present?
      command_request.is_a?(self) && command_request.cartoon_script?
    else
      classname == name && category == ContentCategory::CARTOON_SCRIPT
    end
  end

  def prompt
    super.presence || image_prompt&.prompt
  end

  def latest_image_message
    candidates = [
      user_picture_messages.order(created_at: :desc).first,
      user_image_url_messages.order(created_at: :desc).first
    ].compact

    candidates.max_by(&:created_at)
  end
end
