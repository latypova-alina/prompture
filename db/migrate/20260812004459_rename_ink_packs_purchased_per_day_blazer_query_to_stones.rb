class RenameInkPacksPurchasedPerDayBlazerQueryToStones < ActiveRecord::Migration[8.0]
  OLD_NAME = "Ink packs purchased per day".freeze
  NEW_NAME = "Stone packs purchased per day".freeze

  OLD_STATEMENT = <<~SQL
    SELECT
      DATE(created_at) AS day,
      CASE pack_key
        WHEN 'small' THEN '50 inks'
        WHEN 'medium' THEN '100 inks'
        WHEN 'large' THEN '200 inks'
        ELSE pack_key
      END AS pack,
      COUNT(*) AS packs_purchased
    FROM stars_purchases
    GROUP BY 1, 2
    ORDER BY 1, 2
  SQL

  NEW_STATEMENT = <<~SQL
    SELECT
      DATE(created_at) AS day,
      CASE pack_key
        WHEN 'small' THEN '50 stones'
        WHEN 'medium' THEN '100 stones'
        WHEN 'large' THEN '200 stones'
        ELSE pack_key
      END AS pack,
      COUNT(*) AS packs_purchased
    FROM stars_purchases
    GROUP BY 1, 2
    ORDER BY 1, 2
  SQL

  def up
    Blazer::Query.find_by!(name: OLD_NAME).update!(name: NEW_NAME, statement: NEW_STATEMENT)
  end

  def down
    Blazer::Query.find_by(name: NEW_NAME)&.update!(name: OLD_NAME, statement: OLD_STATEMENT)
  end
end
