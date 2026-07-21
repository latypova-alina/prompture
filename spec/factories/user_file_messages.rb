FactoryBot.define do
  factory :user_file_message do
    file_id { "BQACAgIAAxkBAAIHp..." }
    tg_message_id { 123_456 }
    size { 1.megabyte }
    association :command_request, factory: :command_image_to_video_request
    association :parent_request, factory: :command_image_to_video_request
  end
end
