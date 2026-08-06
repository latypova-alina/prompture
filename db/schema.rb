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

ActiveRecord::Schema[8.0].define(version: 2026_08_06_131906) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "audio_prompts", force: :cascade do |t|
    t.text "prompt", null: false
    t.bigint "video_prompt_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_prompt_id"], name: "index_audio_prompts_on_video_prompt_id"
  end

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

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "bot_telegram_messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "tg_message_id", null: false
    t.string "request_type", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "tg_message_id"], name: "index_bot_telegram_messages_on_chat_and_message", unique: true
    t.index ["request_type", "request_id"], name: "index_telegram_messages_on_request"
  end

  create_table "button_audio_processing_requests", force: :cascade do |t|
    t.string "audio_url"
    t.string "status", default: "pending", null: false
    t.string "processor", null: false
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "voice", default: "adam", null: false
    t.bigint "audio_prompt_id"
    t.index ["audio_prompt_id"], name: "index_button_audio_processing_requests_on_audio_prompt_id"
    t.index ["command_request_type", "command_request_id"], name: "index_button_audio_processing_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_audio_processing_requests_on_parent_request"
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
    t.string "fal_request_id"
    t.bigint "interim_tg_message_id"
    t.index ["command_request_type", "command_request_id"], name: "index_button_image_processing_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_image_processing_requests_on_parent_request"
  end

  create_table "button_merge_audio_video_processing_requests", force: :cascade do |t|
    t.string "video_url"
    t.string "source_video_url", null: false
    t.string "source_audio_url", null: false
    t.string "status", default: "pending", null: false
    t.string "processor", null: false
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command_request_type", "command_request_id"], name: "index_btn_merge_av_requests_on_command"
    t.index ["parent_request_type", "parent_request_id"], name: "index_btn_merge_av_requests_on_parent"
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
    t.string "image_url", null: false
    t.string "fal_request_id"
    t.bigint "interim_tg_message_id"
    t.index ["command_request_type", "command_request_id"], name: "index_button_video_processing_requests_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_button_video_processing_requests_on_parent_request"
  end

  create_table "command_edit_image_requests", force: :cascade do |t|
    t.text "prompt"
    t.bigint "chat_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.bigint "image_prompt_id"
    t.index ["category"], name: "index_command_edit_image_requests_on_category"
    t.index ["image_prompt_id"], name: "index_command_edit_image_requests_on_image_prompt_id"
    t.index ["user_id"], name: "index_command_edit_image_requests_on_user_id"
  end

  create_table "command_image_to_video_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "awaiting_video_prompt", default: false, null: false
    t.index ["user_id"], name: "index_command_image_to_video_requests_on_user_id"
  end

  create_table "command_prompt_to_audio_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["category"], name: "index_command_prompt_to_audio_requests_on_category"
    t.index ["user_id"], name: "index_command_prompt_to_audio_requests_on_user_id"
  end

  create_table "command_prompt_to_image_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "category"
    t.index ["category"], name: "index_command_prompt_to_image_requests_on_category"
    t.index ["user_id"], name: "index_command_prompt_to_image_requests_on_user_id"
  end

  create_table "command_prompt_to_video_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "category"
    t.index ["category"], name: "index_command_prompt_to_video_requests_on_category"
    t.index ["user_id"], name: "index_command_prompt_to_video_requests_on_user_id"
  end

  create_table "command_two_frame_to_video_requests", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id"
    t.string "start_image_url"
    t.string "end_image_url"
    t.text "prompt"
    t.boolean "awaiting_video_prompt", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_command_two_frame_to_video_requests_on_user_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "image_prompts", force: :cascade do |t|
    t.text "prompt"
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
    t.string "subcategory"
    t.bigint "video_prompt_id"
    t.index ["command_request_type", "command_request_id"], name: "index_prompt_messages_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_prompt_messages_on_parent_request"
    t.index ["subcategory"], name: "index_prompt_messages_on_subcategory"
    t.index ["video_prompt_id"], name: "index_prompt_messages_on_video_prompt_id"
  end

  create_table "scenes", force: :cascade do |t|
    t.text "scene_text", null: false
    t.bigint "video_prompt_id"
    t.bigint "image_prompt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "script_id", null: false
    t.integer "order", default: 1, null: false
    t.index ["image_prompt_id"], name: "index_scenes_on_image_prompt_id"
    t.index ["script_id", "order"], name: "index_scenes_on_script_id_and_order"
    t.index ["script_id"], name: "index_scenes_on_script_id"
    t.index ["video_prompt_id"], name: "index_scenes_on_video_prompt_id"
  end

  create_table "scripts", force: :cascade do |t|
    t.boolean "chained_references", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stars_purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "telegram_payment_charge_id", null: false
    t.string "pack_key", null: false
    t.integer "stars_amount", null: false
    t.integer "credits_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["telegram_payment_charge_id"], name: "index_stars_purchases_on_telegram_payment_charge_id", unique: true
    t.index ["user_id"], name: "index_stars_purchases_on_user_id"
  end

  create_table "stored_images", force: :cascade do |t|
    t.string "image_url", null: false
    t.string "source_message_type", null: false
    t.bigint "source_message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "image_prompt_id"
    t.index ["image_prompt_id"], name: "index_stored_images_on_image_prompt_id"
    t.index ["source_message_type", "source_message_id"], name: "idx_on_source_message_type_source_message_id_b22a70b9b7", unique: true
    t.index ["source_message_type", "source_message_id"], name: "index_stored_images_on_source_message"
  end

  create_table "stored_videos", force: :cascade do |t|
    t.string "video_url", null: false
    t.string "category"
    t.string "subcategory"
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "subcategory"], name: "index_stored_videos_on_category_and_subcategory"
    t.index ["source_type", "source_id"], name: "index_stored_videos_on_source"
    t.index ["source_type", "source_id"], name: "index_stored_videos_on_source_type_and_source_id", unique: true
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

  create_table "user_file_messages", force: :cascade do |t|
    t.string "file_id"
    t.integer "size"
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tg_message_id"
    t.index ["command_request_type", "command_request_id"], name: "index_user_file_messages_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_user_file_messages_on_parent_request"
  end

  create_table "user_image_url_messages", force: :cascade do |t|
    t.string "image_url"
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tg_message_id"
    t.index ["command_request_type", "command_request_id"], name: "index_user_image_url_messages_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_user_image_url_messages_on_parent_request"
  end

  create_table "user_picture_messages", force: :cascade do |t|
    t.string "picture_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.string "parent_request_type", null: false
    t.bigint "parent_request_id", null: false
    t.string "command_request_type", null: false
    t.bigint "command_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tg_message_id"
    t.index ["command_request_type", "command_request_id"], name: "index_user_picture_messages_on_command_request"
    t.index ["parent_request_type", "parent_request_id"], name: "index_user_picture_messages_on_parent_request"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", default: "en", null: false
    t.boolean "admin", default: false, null: false
    t.index ["chat_id"], name: "index_users_on_chat_id", unique: true
  end

  create_table "video_prompts", force: :cascade do |t|
    t.text "prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "welcome_bonuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "slot_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slot_number"], name: "index_welcome_bonuses_on_slot_number", unique: true
    t.index ["user_id"], name: "index_welcome_bonuses_on_user_id", unique: true
    t.check_constraint "slot_number <= 100", name: "welcome_bonuses_slot_number_cap"
  end

  add_foreign_key "audio_prompts", "video_prompts"
  add_foreign_key "balance_transactions", "users"
  add_foreign_key "balances", "users"
  add_foreign_key "button_audio_processing_requests", "audio_prompts"
  add_foreign_key "command_edit_image_requests", "image_prompts"
  add_foreign_key "command_edit_image_requests", "users"
  add_foreign_key "command_image_to_video_requests", "users"
  add_foreign_key "command_prompt_to_audio_requests", "users"
  add_foreign_key "command_prompt_to_image_requests", "users"
  add_foreign_key "command_prompt_to_video_requests", "users"
  add_foreign_key "command_two_frame_to_video_requests", "users"
  add_foreign_key "prompt_messages", "video_prompts"
  add_foreign_key "scenes", "image_prompts"
  add_foreign_key "scenes", "scripts"
  add_foreign_key "scenes", "video_prompts"
  add_foreign_key "stars_purchases", "users"
  add_foreign_key "stored_images", "image_prompts"
  add_foreign_key "tokens", "users"
  add_foreign_key "welcome_bonuses", "users"
end
