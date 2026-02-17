class ButtonVideoProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  PROCESSOR_TYPES = %w[kling_2_1_pro_image_to_video].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }

  def cost
    COSTS[:videos][processor.to_sym]
  end
end
