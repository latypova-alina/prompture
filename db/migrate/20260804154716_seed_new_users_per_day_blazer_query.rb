class SeedNewUsersPerDayBlazerQuery < ActiveRecord::Migration[8.0]
  def up
    Blazer::Query.create!(
      name: "New users per day",
      data_source: "main",
      statement: <<~SQL
        SELECT DATE(created_at) AS day, COUNT(*) AS new_users
        FROM users
        WHERE admin = false
        GROUP BY 1
        ORDER BY 1
      SQL
    )
  end

  def down
    Blazer::Query.find_by(name: "New users per day")&.destroy
  end
end
