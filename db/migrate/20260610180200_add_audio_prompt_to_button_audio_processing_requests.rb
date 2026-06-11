class AddAudioPromptToButtonAudioProcessingRequests < ActiveRecord::Migration[8.0]
  def change
    add_reference :button_audio_processing_requests, :audio_prompt, foreign_key: true
  end
end
