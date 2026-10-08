class AddFalPayloadToButtonRequests < ActiveRecord::Migration[8.0]
  TABLES = %i[
    button_image_processing_requests
    button_video_processing_requests
    button_audio_processing_requests
  ].freeze

  def change
    TABLES.each { |table| add_column table, :fal_payload, :jsonb }
  end
end
