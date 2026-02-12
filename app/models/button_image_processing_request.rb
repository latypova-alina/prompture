class ButtonImageProcessingRequest < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  def cost
    COSTS[:images][processor.to_sym]
  end
end
