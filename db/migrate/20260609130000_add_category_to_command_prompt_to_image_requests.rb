class AddCategoryToCommandPromptToImageRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_prompt_to_image_requests, :category, :string
    add_index :command_prompt_to_image_requests, :category
  end
end
