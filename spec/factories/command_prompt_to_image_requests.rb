FactoryBot.define do
  factory :command_prompt_to_image_request do
    chat_id { 456 }
    association :user, factory: %i[user with_balance]
    category { nil }

    trait :cartoon_script do
      category { ContentCategory::CARTOON_SCRIPT }
    end
  end
end
