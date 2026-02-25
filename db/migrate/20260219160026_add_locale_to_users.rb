class AddLocaleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :locale, :string, null: false, default: "en"

    add_reference :command_prompt_to_image_requests, :user, foreign_key: true
    add_reference :command_prompt_to_video_requests, :user, foreign_key: true
    add_reference :command_image_from_reference_requests, :user, foreign_key: true
    add_reference :command_image_to_video_requests, :user, foreign_key: true
  end
end
