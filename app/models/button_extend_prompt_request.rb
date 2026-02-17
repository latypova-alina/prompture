class ButtonExtendPromptRequest < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  def cost
    0
  end
end
