FactoryBot.define do
  factory :image_message do
    image_url { "https://example.com/image.png" }
    association :command_request, factory: :command_prompt_to_image_request
    association :parent_request, factory: :command_prompt_to_image_request
  end
end
