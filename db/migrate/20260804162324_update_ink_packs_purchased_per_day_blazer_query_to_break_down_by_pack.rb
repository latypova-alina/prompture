class UpdateInkPacksPurchasedPerDayBlazerQueryToBreakDownByPack < ActiveRecord::Migration[8.0]
  OLD_STATEMENT = <<~SQL
    SELECT DATE(created_at) AS day, COUNT(*) AS packs_purchased
    FROM stars_purchases
    GROUP BY 1
    ORDER BY 1
  SQL

  NEW_STATEMENT = <<~SQL
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

  def up
    Blazer::Query.find_by!(name: "Ink packs purchased per day").update!(statement: NEW_STATEMENT)
  end

  def down
    Blazer::Query.find_by(name: "Ink packs purchased per day")&.update!(statement: OLD_STATEMENT)
  end
end
