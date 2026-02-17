class ButtonImageProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  PROCESSOR_TYPES = %w[mystic_image gemini_image imagen_image].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  def cost
    COSTS[:images][processor.to_sym]
  end
end
