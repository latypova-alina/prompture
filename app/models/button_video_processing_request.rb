class ButtonVideoProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  PROCESSOR_TYPES = %w[kling_2_1_pro_image_to_video].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :telegram_message, as: :request, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  delegate :user, :chat_id, to: :command_request

  def cost
    COSTS[:generate_video][processor.to_sym]
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.video.#{processor}")
  end
end
