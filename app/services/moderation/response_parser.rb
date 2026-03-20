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

  private

  def results
    response.dig("results", 0) || {}
  end

  def category_scores
    results["category_scores"] || {}
  end

  def categories
    results["categories"] || {}
  end
end
