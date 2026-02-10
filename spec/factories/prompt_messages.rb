FactoryBot.define do
  factory :prompt_message do
    prompt { "Cute little kitten" }
    association :command_request, factory: :command_prompt_to_image_request
    association :parent_request, factory: :command_prompt_to_image_request
  end
end
