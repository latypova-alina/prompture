FactoryBot.define do
  factory :command_prompt_to_image_request do
    prompt { "cute white kitten" }
    chat_id { 456 }
  end
end
