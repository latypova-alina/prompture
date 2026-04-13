class PromptMessage < ApplicationRecord
  include HasOriginPrompt

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  delegate :chat_id, to: :command_request

  has_one :bot_telegram_message, as: :request, dependent: :destroy
end
