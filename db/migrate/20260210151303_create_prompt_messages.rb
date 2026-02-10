class CreatePromptMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :prompt_messages do |t|
      t.text :prompt
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end

    remove_column :command_prompt_to_video_requests, :prompt, :text
    remove_column :command_prompt_to_video_requests, :image_url, :string
    remove_column :command_prompt_to_video_requests, :video_url, :string

    remove_column :command_prompt_to_image_requests, :prompt, :text
  end
end