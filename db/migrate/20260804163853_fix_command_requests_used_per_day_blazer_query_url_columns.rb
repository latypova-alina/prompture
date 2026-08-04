class FixCommandRequestsUsedPerDayBlazerQueryUrlColumns < ActiveRecord::Migration[8.0]
  OLD_STATEMENT = <<~SQL
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

  NEW_STATEMENT = <<~SQL
    SELECT
      DATE(finished_at) AS day,
      command_request_type AS command,
      COUNT(*) AS requests_used
    FROM (
      SELECT updated_at AS finished_at, command_request_type
      FROM button_image_processing_requests
      WHERE image_url IS NOT NULL AND image_url <> ''
        AND command_request_type IN ('CommandPromptToImageRequest', 'CommandEditImageRequest')

      UNION ALL

      SELECT updated_at AS finished_at, command_request_type
      FROM button_video_processing_requests
      WHERE video_url IS NOT NULL AND video_url <> ''
        AND command_request_type IN ('CommandPromptToVideoRequest', 'CommandImageToVideoRequest', 'CommandTwoFrameToVideoRequest')

      UNION ALL

      SELECT updated_at AS finished_at, command_request_type
      FROM button_audio_processing_requests
      WHERE audio_url IS NOT NULL AND audio_url <> ''
        AND command_request_type = 'CommandPromptToAudioRequest'
    ) finished_requests
    GROUP BY 1, 2
    ORDER BY 1, 2
  SQL

  def up
    Blazer::Query.find_by!(name: "Command requests used per day").update!(statement: NEW_STATEMENT)
  end

  def down
    Blazer::Query.find_by(name: "Command requests used per day")&.update!(statement: OLD_STATEMENT)
  end
end
