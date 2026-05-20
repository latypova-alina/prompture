class CreatePromptToAudioRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :command_prompt_to_audio_requests do |t|
      t.bigint :chat_id, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    create_table :button_audio_processing_requests do |t|
      t.string :audio_url
      t.string :status, null: false, default: "pending"
      t.string :processor, null: false
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end
  end
end
