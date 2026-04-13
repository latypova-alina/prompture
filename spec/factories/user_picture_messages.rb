FactoryBot.define do
  factory :user_picture_message do
    picture_id { "AgACAgIAAxkBAAIB..." }
    tg_message_id { 123_456 }
    size { 500.kilobytes }
    width { 960 }
    height { 1280 }
    association :command_request, factory: :command_image_to_video_request
    association :parent_request, factory: :command_image_to_video_request
  end
end
