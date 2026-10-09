class Moderation::OpenaiModerationBase
  include Memery

  MODEL = "omni-moderation-latest".freeze

  def self.decision(...)
    new(...).decision
  end

  memoize def decision
    Moderation::Decision.new(Moderation::ResponseParser.new(response))
  end

  private

  def response
    OpenAIClient.moderations(
      parameters: {
        model: MODEL,
        input:
      }
    )
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    raise ModerationRequestError, e.message
  end

  def input
    raise NotImplementedError
  end
end
