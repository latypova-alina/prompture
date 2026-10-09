# Runs one moderation call and records its outcome. A failed call is recorded too, then
# re-raised so callers keep handling ModerationRequestError as before.
class Moderation::RecordedCheck
  def self.call(...)
    new(...).call
  end

  def initialize(moderation:, input:)
    @moderation = moderation
    @input = input
  end

  def call
    Moderation::ResultRecorder.call(input:, decision:)
  rescue ModerationRequestError => e
    Moderation::ResultRecorder.call(input:, error: e.message)
    raise
  end

  private

  attr_reader :moderation, :input

  delegate :decision, to: :moderation
end
