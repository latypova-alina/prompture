class AddVoiceToButtonAudioProcessingRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :button_audio_processing_requests, :voice, :string, null: false, default: "adam"
  end
end
