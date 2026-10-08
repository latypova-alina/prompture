# Our verdict on one moderation response: whether to block, and which of our rules fired.
# Rules are checked in this order and the first one that fires is reported.
class Moderation::Decision
  include Memery

  VIOLENCE_SCORE_THRESHOLD = 0.7
  VIOLENCE_GRAPHIC_SCORE_THRESHOLD = 0.4
  SEXUAL_SCORE_THRESHOLD = 0.8

  def initialize(parser)
    @parser = parser
  end

  delegate :openai_flagged, :result, to: :parser

  def blocked?
    blocked_by.present?
  end

  memoize def blocked_by
    return "sexual_minors_category" if sexual_minors_category
    return "hate_threatening_category" if hate_threatening_category
    return "violence_score" if violence_score > VIOLENCE_SCORE_THRESHOLD
    return "violence_graphic_score" if violence_graphic_score > VIOLENCE_GRAPHIC_SCORE_THRESHOLD

    "sexual_score" if sexual_score > SEXUAL_SCORE_THRESHOLD
  end

  private

  attr_reader :parser

  delegate :violence_score, :violence_graphic_score, :sexual_score, :sexual_minors_category,
           :hate_threatening_category, to: :parser
end
