class AddImageUrlToButtonVideoProcessingRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :button_video_processing_requests, :image_url, :string, null: false
  end
end
