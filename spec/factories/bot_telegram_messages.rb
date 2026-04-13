FactoryBot.define do
  factory :bot_telegram_message do
    chat_id { 456 }
    tg_message_id { 789 }
    association :request, factory: :command_prompt_to_image_request
  end
end
