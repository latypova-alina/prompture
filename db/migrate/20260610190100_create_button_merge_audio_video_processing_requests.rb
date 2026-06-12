class CreateButtonMergeAudioVideoProcessingRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :button_merge_audio_video_processing_requests do |t|
      t.string :video_url
      t.string :source_video_url, null: false
      t.string :source_audio_url, null: false
      t.string :status, default: "pending", null: false
      t.string :processor, null: false
      t.references :parent_request, polymorphic: true, null: false,
                                    index: { name: "index_btn_merge_av_requests_on_parent" }
      t.references :command_request, polymorphic: true, null: false,
                                     index: { name: "index_btn_merge_av_requests_on_command" }

      t.timestamps
    end
  end
end
