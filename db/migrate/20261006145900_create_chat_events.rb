class CreateChatEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_events do |t|
      t.references :user, foreign_key: true, index: false
      t.bigint :chat_id, null: false
      t.string :direction, null: false
      t.string :kind, null: false
      t.bigint :tg_message_id
      t.bigint :reply_to_message_id
      t.bigint :update_id
      t.datetime :occurred_at, null: false
      t.text :text
      t.jsonb :payload, null: false, default: {}
      t.timestamps
    end

    add_index :chat_events, %i[chat_id occurred_at]
    add_index :chat_events, %i[user_id occurred_at]
    add_index :chat_events, :update_id, unique: true
    add_index :chat_events, :occurred_at
    # answerCallbackQuery carries no chat_id - it's resolved from the incoming callback_query event.
    add_index :chat_events, "(payload->>'callback_query_id')",
              name: "index_chat_events_on_callback_query_id", where: "kind = 'callback_query'"
    add_check_constraint :chat_events, "direction IN ('incoming', 'outgoing')", name: "chat_events_direction"
  end
end
