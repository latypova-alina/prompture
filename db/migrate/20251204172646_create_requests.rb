class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    # command_*_requests are created when user picks a command from the commands list

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

    create_table :button_extend_prompt_requests do |t|
      t.text :prompt, null: true
      t.string :status, null: false, default: "pending"
      t.references :parent_request, polymorphic: true, null: false

      t.timestamps
    end

    create_table :button_image_processing_requests do |t|
      t.string :image_url
      t.string :status, null: false, default: "pending"
      t.references :parent_request, polymorphic: true, null: false
      t.string :processor, null: false

      t.timestamps
    end

    create_table :button_video_processing_requests do |t|
      t.string :video_url
      t.string :status, null: false, default: "pending"
      t.references :parent_request, polymorphic: true, null: false
      t.string :processor, null: false

      t.timestamps
    end

    # button_parent_messages are created to keep track of the messages with inline keyboards. 
    # When any message that contains buttons is generated, a button_parent_message is created.
    #
    # Use case: we want to generate image from the same prompt message for several times by clicking the same button. 
    # How do we know which prompt to use? We look up the button_parent_message by tg_message_id, 
    # then we get the request associated with it and then we get the prompt from that request.
    # 
    
    create_table :button_parent_messages do |t|
      t.bigint :tg_message_id, null: false
      t.references :request, polymorphic: true, null: false, index: true

      t.timestamps
    end

    # button_child_messages are created to keep track of the messages with inline keyboards. 
    # When any button is pressed, a button_child_message is created.
    
    create_table :button_child_messages do |t|
      t.references :request, polymorphic: true, null: false, index: true
      t.references :button_parent_message, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
