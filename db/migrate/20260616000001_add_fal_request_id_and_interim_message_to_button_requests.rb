class AddFalRequestIdAndInterimMessageToButtonRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :button_video_processing_requests, :fal_request_id, :string
    add_column :button_video_processing_requests, :interim_tg_message_id, :bigint

    add_column :button_image_processing_requests, :fal_request_id, :string
    add_column :button_image_processing_requests, :interim_tg_message_id, :bigint
  end
end
