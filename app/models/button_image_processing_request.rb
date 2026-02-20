class ButtonImageProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  PROCESSOR_TYPES = %w[mystic_image gemini_image imagen_image].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :telegram_message, as: :request, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  delegate :user, to: :command_request

  def cost
    COSTS[:images][processor.to_sym]
  end

  def humanized_process_name
    processor.humanize
  end
end
