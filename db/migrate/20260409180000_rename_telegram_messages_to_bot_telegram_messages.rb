class RenameTelegramMessagesToBotTelegramMessages < ActiveRecord::Migration[8.0]
  def up
    remove_index :telegram_messages, name: "index_telegram_messages_on_chat_and_message"

    rename_table :telegram_messages, :bot_telegram_messages

    add_index :bot_telegram_messages, [:chat_id, :tg_message_id], unique: true,
                                                              name: "index_bot_telegram_messages_on_chat_and_message"
  end

  def down
    remove_index :bot_telegram_messages, name: "index_bot_telegram_messages_on_chat_and_message"

    rename_table :bot_telegram_messages, :telegram_messages

    add_index :telegram_messages, [:chat_id, :tg_message_id], unique: true,
                                                          name: "index_telegram_messages_on_chat_and_message"
  end
end
