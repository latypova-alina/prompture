FactoryBot.define do
  factory :command_edit_image_request do
    chat_id { 456 }
    association :user, factory: %i[user with_balance]
  end
end
