Moderation::ResponseParser = Struct.new(:response) do
  def violence_score
    category_scores["violence"].to_f
  end

  def violence_graphic_score
    category_scores["violence/graphic"].to_f
  end

  def sexual_score
    category_scores["sexual"].to_f
  end

  def hate_threatening_category
    categories["hate/threatening"]
  end

  def sexual_minors_category
    categories["sexual/minors"]
  end

  # OpenAI's own verdict, which our rules don't use.
  def openai_flagged
    result["flagged"]
  end

  # The whole results[0] object: categories, category_scores, category_applied_input_types, flagged.
  def result
    response.dig("results", 0) || {}
  end

  private

  def category_scores
    result["category_scores"] || {}
  end

  def categories
    result["categories"] || {}
  end
end
