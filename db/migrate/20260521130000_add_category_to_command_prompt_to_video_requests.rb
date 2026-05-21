class AddCategoryToCommandPromptToVideoRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_prompt_to_video_requests, :category, :string
    add_index :command_prompt_to_video_requests, :category
  end
end
