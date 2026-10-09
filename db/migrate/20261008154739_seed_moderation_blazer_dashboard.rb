class SeedModerationBlazerDashboard < ActiveRecord::Migration[8.0]
  DASHBOARD = "Moderation".freeze
  REJECTED_QUERY = "Passed moderation, rejected by fal".freeze
  SCORES_QUERY = "Moderation scores of fal rejections vs successes".freeze

  # fal-backed button requests with the command they belong to.
  BUTTON_REQUESTS = <<~SQL.freeze
    fal_requests AS (
      SELECT id, 'ButtonImageProcessingRequest' AS type, processor, status, failure_reason, failure_message,
             fal_payload, command_request_type, command_request_id, created_at
      FROM button_image_processing_requests
      UNION ALL
      SELECT id, 'ButtonVideoProcessingRequest', processor, status, failure_reason, failure_message,
             fal_payload, command_request_type, command_request_id, created_at
      FROM button_video_processing_requests
      UNION ALL
      SELECT id, 'ButtonAudioProcessingRequest', processor, status, failure_reason, failure_message,
             fal_payload, command_request_type, command_request_id, created_at
      FROM button_audio_processing_requests
    ),
    -- Moderation of the user's inputs only, not of images fal generated (those point at a button request).
    input_moderations AS (
      SELECT *
      FROM moderation_results
      WHERE moderatable_type IS NULL OR moderatable_type NOT LIKE 'Button%'
    )
  SQL

  REJECTED_STATEMENT = <<~SQL.freeze
    WITH #{BUTTON_REQUESTS},
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
    )
    SELECT
      DATE(fal_requests.created_at) AS day,
      users.id AS user_id,
      users.name AS user_name,
      fal_requests.type,
      fal_requests.id AS button_request_id,
      fal_requests.processor,
      fal_requests.failure_message AS fal_message,
      fal_requests.fal_payload ->> 'prompt' AS prompt_sent_to_fal,
      input_moderations.input_kind,
      input_moderations.input_text AS user_prompt,
      input_moderations.blocked_by,
      input_moderations.openai_flagged,
      (input_moderations.result -> 'category_scores' ->> 'violence')::numeric AS violence,
      (input_moderations.result -> 'category_scores' ->> 'violence/graphic')::numeric AS violence_graphic,
      (input_moderations.result -> 'category_scores' ->> 'sexual')::numeric AS sexual,
      (input_moderations.result -> 'category_scores' ->> 'harassment')::numeric AS harassment,
      (input_moderations.result -> 'category_scores' ->> 'hate')::numeric AS hate,
      (input_moderations.result -> 'category_scores' ->> 'illicit')::numeric AS illicit,
      (input_moderations.result -> 'category_scores' ->> 'self-harm')::numeric AS self_harm
    FROM fal_requests
    JOIN command_users
      ON command_users.type = fal_requests.command_request_type AND command_users.id = fal_requests.command_request_id
    JOIN users ON users.id = command_users.user_id
    LEFT JOIN input_moderations
      ON input_moderations.command_request_type = fal_requests.command_request_type
     AND input_moderations.command_request_id = fal_requests.command_request_id
    WHERE fal_requests.failure_reason = 'content_flagged'
    ORDER BY fal_requests.created_at DESC
  SQL

  # Each input counts once per outcome, however many generations its command had.
  SCORES_STATEMENT = <<~SQL.freeze
    WITH #{BUTTON_REQUESTS},
    outcomes AS (
      SELECT DISTINCT
        input_moderations.id,
        CASE WHEN fal_requests.failure_reason = 'content_flagged' THEN 'rejected by fal' ELSE 'completed' END AS outcome,
        input_moderations.result
      FROM fal_requests
      JOIN input_moderations
        ON input_moderations.command_request_type = fal_requests.command_request_type
       AND input_moderations.command_request_id = fal_requests.command_request_id
      WHERE input_moderations.result IS NOT NULL
        AND (fal_requests.failure_reason = 'content_flagged' OR upper(fal_requests.status) = 'COMPLETED')
    )
    SELECT
      outcome,
      scores.key AS category,
      COUNT(*) AS inputs,
      ROUND(AVG(scores.value::numeric), 4) AS avg_score,
      ROUND(MAX(scores.value::numeric), 4) AS max_score
    FROM outcomes, jsonb_each_text(outcomes.result -> 'category_scores') AS scores
    GROUP BY 1, 2
    ORDER BY 2, 1
  SQL

  def up
    dashboard = Blazer::Dashboard.create!(name: DASHBOARD)

    [[REJECTED_QUERY, REJECTED_STATEMENT], [SCORES_QUERY, SCORES_STATEMENT]].each_with_index do |(name, statement), position|
      query = Blazer::Query.create!(name:, data_source: "main", statement:)
      Blazer::DashboardQuery.create!(dashboard:, query:, position:)
    end
  end

  def down
    Blazer::Query.where(name: [REJECTED_QUERY, SCORES_QUERY]).destroy_all
    Blazer::Dashboard.find_by(name: DASHBOARD)&.destroy
  end
end
