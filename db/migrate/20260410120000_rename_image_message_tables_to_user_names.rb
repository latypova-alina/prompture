class RenameImageMessageTablesToUserNames < ActiveRecord::Migration[8.0]
  def up
    rename_table :image_url_messages, :user_image_url_messages
    rename_table :picture_messages, :user_picture_messages

    rename_index :user_image_url_messages,
                 "index_image_url_messages_on_command_request",
                 "index_user_image_url_messages_on_command_request"
    rename_index :user_image_url_messages,
                 "index_image_url_messages_on_parent_request",
                 "index_user_image_url_messages_on_parent_request"
    rename_index :user_picture_messages,
                 "index_picture_messages_on_command_request",
                 "index_user_picture_messages_on_command_request"
    rename_index :user_picture_messages,
                 "index_picture_messages_on_parent_request",
                 "index_user_picture_messages_on_parent_request"

    update_polymorphic_type("bot_telegram_messages", "request_type", "ImageUrlMessage", "UserImageUrlMessage")
    update_polymorphic_type("bot_telegram_messages", "request_type", "PictureMessage", "UserPictureMessage")
    update_polymorphic_type("stored_images", "source_message_type", "ImageUrlMessage", "UserImageUrlMessage")
    update_polymorphic_type("stored_images", "source_message_type", "PictureMessage", "UserPictureMessage")
    update_polymorphic_type("button_image_processing_requests", "parent_request_type", "ImageUrlMessage", "UserImageUrlMessage")
    update_polymorphic_type("button_image_processing_requests", "parent_request_type", "PictureMessage", "UserPictureMessage")
    update_polymorphic_type("button_video_processing_requests", "parent_request_type", "ImageUrlMessage", "UserImageUrlMessage")
    update_polymorphic_type("button_video_processing_requests", "parent_request_type", "PictureMessage", "UserPictureMessage")
    update_polymorphic_type("prompt_messages", "parent_request_type", "ImageUrlMessage", "UserImageUrlMessage")
    update_polymorphic_type("prompt_messages", "parent_request_type", "PictureMessage", "UserPictureMessage")
  end

  def down
    update_polymorphic_type("bot_telegram_messages", "request_type", "UserImageUrlMessage", "ImageUrlMessage")
    update_polymorphic_type("bot_telegram_messages", "request_type", "UserPictureMessage", "PictureMessage")
    update_polymorphic_type("stored_images", "source_message_type", "UserImageUrlMessage", "ImageUrlMessage")
    update_polymorphic_type("stored_images", "source_message_type", "UserPictureMessage", "PictureMessage")
    update_polymorphic_type("button_image_processing_requests", "parent_request_type", "UserImageUrlMessage", "ImageUrlMessage")
    update_polymorphic_type("button_image_processing_requests", "parent_request_type", "UserPictureMessage", "PictureMessage")
    update_polymorphic_type("button_video_processing_requests", "parent_request_type", "UserImageUrlMessage", "ImageUrlMessage")
    update_polymorphic_type("button_video_processing_requests", "parent_request_type", "UserPictureMessage", "PictureMessage")
    update_polymorphic_type("prompt_messages", "parent_request_type", "UserImageUrlMessage", "ImageUrlMessage")
    update_polymorphic_type("prompt_messages", "parent_request_type", "UserPictureMessage", "PictureMessage")

    rename_index :user_picture_messages,
                 "index_user_picture_messages_on_command_request",
                 "index_picture_messages_on_command_request"
    rename_index :user_picture_messages,
                 "index_user_picture_messages_on_parent_request",
                 "index_picture_messages_on_parent_request"
    rename_index :user_image_url_messages,
                 "index_user_image_url_messages_on_command_request",
                 "index_image_url_messages_on_command_request"
    rename_index :user_image_url_messages,
                 "index_user_image_url_messages_on_parent_request",
                 "index_image_url_messages_on_parent_request"

    rename_table :user_picture_messages, :picture_messages
    rename_table :user_image_url_messages, :image_url_messages
  end

  private

  def update_polymorphic_type(table_name, column_name, from_value, to_value)
    execute <<~SQL.squish
      UPDATE #{table_name}
      SET #{column_name} = '#{to_value}'
      WHERE #{column_name} = '#{from_value}'
    SQL
  end
end
