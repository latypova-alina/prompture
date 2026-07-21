class CreateCommandTwoFrameToVideoRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :command_two_frame_to_video_requests do |t|
      t.bigint :chat_id, null: false
      t.references :user, foreign_key: true
      t.string :start_image_url
      t.string :end_image_url
      t.text :prompt
      t.boolean :awaiting_video_prompt, null: false, default: false

      t.timestamps
    end
  end
end
