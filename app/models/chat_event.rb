# One incoming update or outgoing Bot API call in a user's conversation with the bot. Append-only,
# kept for 90 days (ChatEvents::RetentionJob). Payloads hold an explicit allowlist, never the raw update.
class ChatEvent < ApplicationRecord
  DIRECTIONS = %w[incoming outgoing].freeze

  belongs_to :user, optional: true

  validates :direction, inclusion: { in: DIRECTIONS }
  validates :chat_id, :kind, :occurred_at, presence: true
end
