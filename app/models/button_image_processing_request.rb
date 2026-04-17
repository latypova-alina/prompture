class ButtonImageProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  PROCESSOR_TYPES = %w[mystic_image flux_image gemini_image imagen_image].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :bot_telegram_message, as: :request, dependent: :destroy
  has_one :stored_image, as: :source_message, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  delegate :user, :chat_id, to: :command_request
  delegate :locale, to: :user
  delegate :image_url, to: :stored_image, prefix: true, allow_nil: true

  def cost
    COSTS[:generate_image][processor.to_sym]
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.image.#{processor}", locale:)
  end

  def resolved_image_url
    stored_image_image_url || image_url
  end
end
