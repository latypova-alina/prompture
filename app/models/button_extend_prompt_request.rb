class ButtonExtendPromptRequest < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :telegram_message, as: :request, dependent: :destroy

  delegate :user, :chat_id, to: :command_request
  delegate :locale, to: :user

  def cost
    COSTS[:prompt][:extend_prompt]
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.extend_prompt")
  end
end
