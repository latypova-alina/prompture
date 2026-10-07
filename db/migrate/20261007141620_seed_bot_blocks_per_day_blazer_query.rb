class SeedBotBlocksPerDayBlazerQuery < ActiveRecord::Migration[8.0]
  def up
    Blazer::Query.create!(
      name: "Bot blocks per day",
      data_source: "main",
      description: "Only blocks we've observed: my_chat_member updates since this shipped, " \
                   "plus older blocks found when a send failed. A user who unblocks drops out.",
      statement: <<~SQL
        SELECT 'currently blocked' AS metric, NULL::date AS day, COUNT(*) AS users
        FROM users
        WHERE blocked_at IS NOT NULL

        UNION ALL

        SELECT 'blocked per day', DATE(blocked_at), COUNT(*)
        FROM users
        WHERE blocked_at IS NOT NULL
        GROUP BY 2

        ORDER BY 1, 2
      SQL
    )
  end

  def down
    Blazer::Query.find_by(name: "Bot blocks per day")&.destroy
  end
end
