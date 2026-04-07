FactoryBot.define do
  factory :picture_message do
    picture_id { "AgACAgIAAxkBAAIB..." }
    size { 500.kilobytes }
    width { 960 }
    height { 1280 }
    association :command_request, factory: :command_image_to_video_request
    association :parent_request, factory: :command_image_to_video_request
  end
end
