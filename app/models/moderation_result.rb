# One OpenAI moderation call on a user input (text prompt or image): our decision, OpenAI's own
# verdict and the raw scores. Blocked text prompts have no PromptMessage, so input_text keeps them.
class ModerationResult < ApplicationRecord
  INPUT_KINDS = %w[text image].freeze

  belongs_to :moderatable, polymorphic: true, optional: true
  belongs_to :command_request, polymorphic: true

  validates :input_kind, inclusion: { in: INPUT_KINDS }
  validates :model, presence: true

  def category_scores
    result.to_h.fetch("category_scores", {})
  end
end
