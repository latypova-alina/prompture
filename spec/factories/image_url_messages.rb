FactoryBot.define do
  factory :image_url_message do
    image_url { "https://example.com/image.png" }
    tg_message_id { 123_456 }
    association :command_request, factory: :command_prompt_to_image_request
    association :parent_request, factory: :command_prompt_to_image_request
  end
end
