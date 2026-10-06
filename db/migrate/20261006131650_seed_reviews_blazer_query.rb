class SeedReviewsBlazerQuery < ActiveRecord::Migration[8.0]
  def up
    Blazer::Query.create!(
      name: "Reviews",
      data_source: "main",
      statement: <<~SQL
        SELECT 'rating' AS metric, rating::text AS bucket, COUNT(*)::numeric AS value
        FROM reviews
        GROUP BY rating

        UNION ALL

        SELECT 'average rating per week', DATE_TRUNC('week', created_at)::date::text, ROUND(AVG(rating), 2)
        FROM reviews
        GROUP BY DATE_TRUNC('week', created_at)

        UNION ALL

        SELECT 'use_cases', option, COUNT(*)
        FROM reviews, jsonb_array_elements_text(answers -> 'use_cases' -> 'selected') AS option
        GROUP BY option

        UNION ALL

        SELECT 'features', option, COUNT(*)
        FROM reviews, jsonb_array_elements_text(answers -> 'features' -> 'selected') AS option
        GROUP BY option

        ORDER BY 1, 2
      SQL
    )
  end

  def down
    Blazer::Query.find_by(name: "Reviews")&.destroy
  end
end
