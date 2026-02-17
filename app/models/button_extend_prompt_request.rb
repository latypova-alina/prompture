class ButtonExtendPromptRequest < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :telegram_message, as: :request, dependent: :destroy

  def cost
    0
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.extend_prompt")
  end
end
