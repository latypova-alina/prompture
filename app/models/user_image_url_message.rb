class UserImageUrlMessage < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  delegate :chat_id, to: :command_request

  has_one :bot_telegram_message, as: :request, dependent: :destroy
  has_one :stored_image, as: :source_message, dependent: :destroy

  delegate :image_url, to: :stored_image, prefix: true, allow_nil: true

  def resolved_image_url
    stored_image_image_url || image_url
  end
end
