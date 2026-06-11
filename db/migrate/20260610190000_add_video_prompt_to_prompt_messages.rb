class AddVideoPromptToPromptMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :prompt_messages, :video_prompt, foreign_key: true
  end
end
