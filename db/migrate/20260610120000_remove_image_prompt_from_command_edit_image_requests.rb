class RemoveImagePromptFromCommandEditImageRequests < ActiveRecord::Migration[8.0]
  def change
    remove_reference :command_edit_image_requests, :image_prompt, foreign_key: true
  end
end
