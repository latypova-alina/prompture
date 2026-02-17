FactoryBot.define do
  factory :button_extend_prompt_request do
    prompt  { "cute white kitten" }
    status  { "PENDING" }

    association :command_request, factory: :command_prompt_to_image_request
    parent_request { command_request }

    trait :completed do
      status { "COMPLETED" }
    end
  end
end
