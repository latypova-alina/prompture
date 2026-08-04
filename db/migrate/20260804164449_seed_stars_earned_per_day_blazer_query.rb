class SeedStarsEarnedPerDayBlazerQuery < ActiveRecord::Migration[8.0]
  def up
    query = Blazer::Query.create!(
      name: "Stars earned per day",
      data_source: "main",
      statement: <<~SQL
        SELECT DATE(created_at) AS day, SUM(stars_amount) AS stars_earned
        FROM stars_purchases
        GROUP BY 1
        ORDER BY 1
      SQL
    )

    dashboard = Blazer::Dashboard.find_by!(name: "Growth")
    Blazer::DashboardQuery.create!(dashboard:, query:, position: 3)
  end

  def down
    Blazer::Query.find_by(name: "Stars earned per day")&.destroy
  end
end
