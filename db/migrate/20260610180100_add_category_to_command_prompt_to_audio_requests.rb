class AddCategoryToCommandPromptToAudioRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_prompt_to_audio_requests, :category, :string
    add_index :command_prompt_to_audio_requests, :category
  end
end
