class AddFailureFieldsToButtonRequests < ActiveRecord::Migration[8.0]
  TABLES = %i[
    button_image_processing_requests
    button_video_processing_requests
    button_audio_processing_requests
    button_merge_audio_video_processing_requests
    button_extend_prompt_requests
  ].freeze

  def change
    TABLES.each do |table|
      add_column table, :failure_reason, :string
      add_column table, :failure_message, :text
    end
  end
end
