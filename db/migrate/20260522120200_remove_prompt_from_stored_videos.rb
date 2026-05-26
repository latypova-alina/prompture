class RemovePromptFromStoredVideos < ActiveRecord::Migration[8.0]
  def change
    remove_column :stored_videos, :prompt, :text
  end
end
