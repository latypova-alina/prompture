class SeedInsufficientCreditsHitsBlazerQuery < ActiveRecord::Migration[8.0]
  NAME = "Insufficient credits hits".freeze

  # One row per (day, processor): distinct users who hit the paywall (so multi-taps count once),
  # and how many of them bought stones within 24h after their first hit that day.
  STATEMENT = <<~SQL.freeze
    WITH hits AS (
      SELECT processor, command_request_type, command_request_id, created_at
      FROM button_image_processing_requests WHERE failure_reason = 'insufficient_credits'
      UNION ALL
      SELECT processor, command_request_type, command_request_id, created_at
      FROM button_video_processing_requests WHERE failure_reason = 'insufficient_credits'
      UNION ALL
      SELECT processor, command_request_type, command_request_id, created_at
      FROM button_audio_processing_requests WHERE failure_reason = 'insufficient_credits'
      UNION ALL
      SELECT processor, command_request_type, command_request_id, created_at
      FROM button_merge_audio_video_processing_requests WHERE failure_reason = 'insufficient_credits'
      UNION ALL
      SELECT 'extend_prompt', command_request_type, command_request_id, created_at
      FROM button_extend_prompt_requests WHERE failure_reason = 'insufficient_credits'
    ),
    command_users AS (
      SELECT 'CommandPromptToImageRequest' AS type, id, user_id FROM command_prompt_to_image_requests
      UNION ALL
      SELECT 'CommandPromptToVideoRequest', id, user_id FROM command_prompt_to_video_requests
      UNION ALL
      SELECT 'CommandImageToVideoRequest', id, user_id FROM command_image_to_video_requests
      UNION ALL
      SELECT 'CommandTwoFrameToVideoRequest', id, user_id FROM command_two_frame_to_video_requests
      UNION ALL
      SELECT 'CommandEditImageRequest', id, user_id FROM command_edit_image_requests
      UNION ALL
      SELECT 'CommandPromptToAudioRequest', id, user_id FROM command_prompt_to_audio_requests
    ),
    first_hits AS (
      SELECT DATE(hits.created_at) AS day, hits.processor, command_users.user_id, MIN(hits.created_at) AS hit_at
      FROM hits
      JOIN command_users
        ON command_users.type = hits.command_request_type AND command_users.id = hits.command_request_id
      GROUP BY 1, 2, 3
    )
    SELECT
      day,
      processor,
      COUNT(*) AS users_hit,
      COUNT(*) FILTER (
        WHERE EXISTS (
          SELECT 1 FROM stars_purchases
          WHERE stars_purchases.user_id = first_hits.user_id
            AND stars_purchases.created_at BETWEEN first_hits.hit_at AND first_hits.hit_at + INTERVAL '24 hours'
        )
      ) AS bought_within_24h
    FROM first_hits
    GROUP BY 1, 2
    ORDER BY 1, 2
  SQL

  def up
    query = Blazer::Query.create!(name: NAME, data_source: "main", statement: STATEMENT)
    dashboard = Blazer::Dashboard.find_by!(name: "Growth")
    position = Blazer::DashboardQuery.where(dashboard:).maximum(:position).to_i + 1

    Blazer::DashboardQuery.create!(dashboard:, query:, position:)
  end

  def down
    Blazer::Query.find_by(name: NAME)&.destroy
  end
end
