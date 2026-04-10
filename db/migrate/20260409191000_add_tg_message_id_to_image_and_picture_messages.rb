class AddTgMessageIdToImageAndPictureMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :image_url_messages, :tg_message_id, :bigint
    add_column :picture_messages, :tg_message_id, :bigint
  end
end
