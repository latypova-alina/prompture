class AddAwaitingVideoPromptToCommandImageToVideoRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_image_to_video_requests, :awaiting_video_prompt, :boolean, default: false, null: false
  end
end
