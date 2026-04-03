FactoryBot.define do
  factory :command_image_to_video_request do
    chat_id { 456 }
    association :user, factory: %i[user with_balance]
  end
end
