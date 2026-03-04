FactoryBot.define do
  factory :button_extend_prompt_request do
    prompt  { "cute white kitten" }
    status  { "PENDING" }

    association :command_request, factory: :command_prompt_to_image_request
    parent_request { command_request }

    trait :completed do
      status { "COMPLETED" }
    end

    trait :belonging_to_user do
      transient { user { create(:user, :with_balance) } }

      command_request { create(:command_prompt_to_image_request, user:) }
    end
  end
end
