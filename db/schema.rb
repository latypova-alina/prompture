# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_11_150545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "balance_transactions", force: :cascade do |t|
    t.integer "amount", null: false
    t.string "transaction_type", null: false
    t.bigint "user_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_balance_transactions_on_source_type_and_source_id"
    t.index ["user_id", "transaction_type", "source_type", "source_id"], name: "index_balance_transactions_uniqueness", unique: true
    t.index ["user_id"], name: "index_balance_transactions_on_user_id"
  end

  create_table "balances", force: :cascade do |t|
    t.integer "credits", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "button_extend_prompt_requests", force: :cascade do |t|
    t.text "prompt"
    t.string "status", default: "pending", null: false
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command_request_type", "command_request_id"], name: "index_button_extend_prompt_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_extend_prompt_requests_on_parent_request"
  end

  create_table "button_image_processing_requests", force: :cascade do |t|
    t.string "image_url"
    t.string "status", default: "pending", null: false
    t.string "processor", null: false
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command_request_type", "command_request_id"], name: "index_button_image_processing_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_image_processing_requests_on_parent_request"
  end

  create_table "button_video_processing_requests", force: :cascade do |t|
    t.string "video_url"
    t.string "status", default: "pending", null: false
    t.string "processor", null: false
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command_request_type", "command_request_id"], name: "index_button_video_processing_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_video_processing_requests_on_parent_request"
  end

  create_table "command_image_from_reference_requests", force: :cascade do |t|
    t.string "reference_picture_id"
    t.string "reference_image_url"
    t.text "prompt"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "command_image_to_video_requests", force: :cascade do |t|
    t.string "reference_picture_id"
    t.string "reference_image_url"
    t.text "prompt"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "command_prompt_to_image_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "command_prompt_to_video_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prompt_messages", force: :cascade do |t|
    t.text "prompt"
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command_request_type", "command_request_id"], name: "index_prompt_messages_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_prompt_messages_on_parent_request"
  end

  create_table "telegram_messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "tg_message_id", null: false
    t.string "request_type", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "tg_message_id"], name: "index_telegram_messages_on_chat_and_message", unique: true
    t.index ["request_type", "request_id"], name: "index_telegram_messages_on_request"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "code", null: false
    t.integer "credits", null: false
    t.text "greeting"
    t.bigint "user_id"
    t.date "expires_at", null: false
    t.date "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tokens_on_code", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_users_on_chat_id", unique: true
  end

  add_foreign_key "balance_transactions", "users"
  add_foreign_key "balances", "users"
  add_foreign_key "tokens", "users"
end
