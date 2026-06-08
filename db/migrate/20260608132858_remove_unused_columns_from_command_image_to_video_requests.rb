class RemoveUnusedColumnsFromCommandImageToVideoRequests < ActiveRecord::Migration[8.0]
  def change
    remove_column :command_image_to_video_requests, :reference_picture_id, :string
    remove_column :command_image_to_video_requests, :reference_image_url, :string
    remove_column :command_image_to_video_requests, :prompt, :text
  end
end
