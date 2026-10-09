# Saves one moderation call as a ModerationResult: the decision when the call worked,
# the error message when it didn't.
class Moderation::ResultRecorder
  def self.call(...)
    new(...).call
  end

  def initialize(input:, decision: nil, error: nil)
    @input = input
    @decision = decision
    @error = error
  end

  def call
    ModerationResult.create!(
      input_kind:, input_text:, command_request:, moderatable:,
      model: Moderation::OpenaiModerationBase::MODEL, error:, **decision_attributes
    )
  end

  private

  attr_reader :input, :decision, :error

  delegate :input_kind, :input_text, :command_request, :moderatable, to: :input
  delegate :blocked?, :blocked_by, :openai_flagged, :result, to: :decision

  def decision_attributes
    return {} if decision.nil?

    { blocked: blocked?, blocked_by:, openai_flagged:, result: }
  end
end
