FactoryBot.define do
  factory :command_prompt_to_video_request do
    prompt { "cute white kitten" }
    image_url { "http://example.com/image.jpg" }
    chat_id { 456 }
  end
end
