class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    # command_*_requests are created when user picks a command from the commands list
    # tg_message_id is a message with buttons generated in response to the command request
    create_table :command_prompt_to_image_requests do |t|
      t.text :prompt
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_prompt_to_video_requests do |t|
      t.text :prompt
      t.string :image_url
      t.string :video_url
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_image_to_video_requests do |t|
      t.string :reference_picture_id
      t.string :reference_image_url
      t.text :prompt
      t.bigint :chat_id, null: false
      t.timestamps
    end

    create_table :command_image_from_reference_requests do |t|
      t.string :reference_picture_id
      t.string :reference_image_url
      t.text :prompt
      t.bigint :chat_id, null: false
      t.timestamps
    end

    # button_*_requests are created when user clicks on inline keyboard buttons
    # tg_message_id is a message with buttons generated in response to the button request
    create_table :button_extend_prompt_requests do |t|
      t.text :prompt, null: true
      t.string :status, null: false, default: "pending"
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end

    create_table :button_image_processing_requests do |t|
      t.string :image_url
      t.string :status, null: false, default: "pending"
      t.string :processor, null: false
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end

    create_table :button_video_processing_requests do |t|
      t.string :video_url
      t.string :status, null: false, default: "pending"
      t.string :processor, null: false
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end

    create_table :telegram_messages do |t|
      t.bigint :chat_id, null: false
      t.bigint :tg_message_id, null: false
      t.references :request, polymorphic: true, null: false
      t.timestamps
    end

    add_index :telegram_messages, [:chat_id, :tg_message_id], unique: true, name: "index_telegram_messages_on_chat_and_message"
  end
end
