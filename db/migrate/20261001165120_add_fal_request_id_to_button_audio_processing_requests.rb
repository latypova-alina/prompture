class AddFalRequestIdToButtonAudioProcessingRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :button_audio_processing_requests, :fal_request_id, :string
  end
end
