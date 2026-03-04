FactoryBot.define do
  factory :command_prompt_to_image_request do
    chat_id { 456 }
    association :user, factory: %i[user with_balance]
  end
end
