class AddCategoryToCommandImageToVideoAndTwoFrameToVideoRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_image_to_video_requests, :category, :string
    add_index :command_image_to_video_requests, :category

    add_column :command_two_frame_to_video_requests, :category, :string
    add_index :command_two_frame_to_video_requests, :category
  end
end
