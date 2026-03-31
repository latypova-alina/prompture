FactoryBot.define do
  factory :button_extend_prompt_request do
    prompt  { "cute white kitten" }
    status  { "PENDING" }

    trait :completed do
      status { "COMPLETED" }
    end

    transient { user { create(:user, :with_balance) } }

    command_request { create(:command_prompt_to_image_request, user:) }
    parent_request { create(:prompt_message, command_request:, parent_request: command_request) }
  end
end
