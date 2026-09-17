class Moderation::OpenaiModeration < Moderation::OpenaiModerationBase
  def initialize(text)
    super()
    @text = text
  end

  private

  attr_reader :text

  def input
    text
  end
end
