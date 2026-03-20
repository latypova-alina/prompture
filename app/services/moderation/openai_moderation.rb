class Moderation::OpenaiModeration
  include Memery

  VIOLENCE_SCORE_THRESHOLD = 0.7
  VIOLENCE_GRAPHIC_SCORE_THRESHOLD = 0.4
  SEXUAL_SCORE_THRESHOLD = 0.8

  def self.flagged?(text)
    new(text).flagged?
  end

  def initialize(text)
    @text = text
  end

  def flagged?
    !!(validate_categories || validate_scores)
  end

  private

  attr_reader :text

  delegate :violence_score, :violence_graphic_score, :sexual_score, :sexual_minors_category, :hate_threatening_category,
           to: :moderation_response_parser

  def validate_categories
    return true if sexual_minors_category

    true if hate_threatening_category
  end

  def validate_scores
    return true if violence_score > VIOLENCE_SCORE_THRESHOLD
    return true if violence_graphic_score > VIOLENCE_GRAPHIC_SCORE_THRESHOLD

    true if sexual_score > SEXUAL_SCORE_THRESHOLD
  end

  memoize def moderation_response_parser
    Moderation::ResponseParser.new(response)
  end

  def response
    OpenAIClient.moderations(
      parameters: {
        model: "omni-moderation-latest",
        input: text
      }
    )
  end
end
