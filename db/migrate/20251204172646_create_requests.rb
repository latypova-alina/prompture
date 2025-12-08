class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :command_prompt_to_image_requests do |t|
      t.text :prompt, null: false
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_prompt_to_video_requests do |t|
      t.text :prompt, null: false
      t.string :image_url
      t.string :video_url
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_image_to_video_requests do |t|
      t.string :reference_picture_id, null: false
      t.string :reference_image_url
      t.string :prompt, null: true
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_image_from_reference_requests do |t|
      t.string :reference_picture_id, null: false
      t.string :reference_image_url
      t.text :prompt, null: true
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :button_extend_prompt_requests do |t|
      t.text :extended_prompt, null: true
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    create_table :button_image_processing_requests do |t|
      t.string :image_url
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    create_table :button_video_processing_requests do |t|
      t.string :video_url
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    add_reference :extend_prompt_requests, :parent_request, polymorphic: true, null: false
  end
end
