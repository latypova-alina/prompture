class ReplaceImageFromReferenceWithEditImage < ActiveRecord::Migration[8.0]
  def change
    drop_table :command_image_from_reference_requests, if_exists: true do |t|
      t.string :reference_picture_id
      t.string :reference_image_url
      t.text :prompt
      t.bigint :chat_id, null: false
      t.timestamps
      t.bigint :user_id
    end

    create_table :command_edit_image_requests do |t|
      t.text :prompt
      t.bigint :chat_id, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
