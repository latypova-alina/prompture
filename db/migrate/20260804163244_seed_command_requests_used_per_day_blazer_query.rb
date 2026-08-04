class SeedCommandRequestsUsedPerDayBlazerQuery < ActiveRecord::Migration[8.0]
  def up
    query = Blazer::Query.create!(
      name: "Command requests used per day",
      data_source: "main",
      statement: <<~SQL
        SELECT
          DATE(finished_at) AS day,
          command_request_type AS command,
          COUNT(*) AS requests_used
        FROM (
          SELECT updated_at AS finished_at, command_request_type
          FROM button_image_processing_requests
          WHERE image_url IS NOT NULL AND image_url <> ''

          UNION ALL

          SELECT updated_at AS finished_at, command_request_type
          FROM button_video_processing_requests
          WHERE video_url IS NOT NULL AND video_url <> ''

          UNION ALL

          SELECT updated_at AS finished_at, command_request_type
          FROM button_audio_processing_requests
          WHERE audio_url IS NOT NULL AND audio_url <> ''
        ) finished_requests
        GROUP BY 1, 2
        ORDER BY 1, 2
      SQL
    )

    dashboard = Blazer::Dashboard.find_by!(name: "Growth")
    Blazer::DashboardQuery.create!(dashboard:, query:, position: 2)
  end

  def down
    Blazer::Query.find_by(name: "Command requests used per day")&.destroy
  end
end
