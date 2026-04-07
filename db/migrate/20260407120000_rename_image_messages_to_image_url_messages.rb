class RenameImageMessagesToImageUrlMessages < ActiveRecord::Migration[8.0]
  def change
    rename_table :image_messages, :image_url_messages

    rename_index :image_url_messages,
                 "index_image_messages_on_command_request",
                 "index_image_url_messages_on_command_request"
    rename_index :image_url_messages,
                 "index_image_messages_on_parent_request",
                 "index_image_url_messages_on_parent_request"
  end
end
