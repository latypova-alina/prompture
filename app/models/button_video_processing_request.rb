class ButtonVideoProcessingRequest < ApplicationRecord
  include HasOriginPrompt
  include HasOriginImage

  PROCESSOR_TYPES = %w[
    kling_2_1_pro_image_to_video
    seedance_1_5_pro_image_to_video
    wan_2_2_image_to_video
  ].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :bot_telegram_message, as: :request, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  delegate :user, :chat_id, to: :command_request
  delegate :locale, to: :user

  def cost
    COSTS[:generate_video][processor.to_sym]
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.video.#{processor}", locale:)
  end

  def resolved_image_url
    origin_image_url
  end
end
