FactoryBot.define do
  factory :button_image_processing_request do
    status { "PENDING" }
    image_url { nil }
    processor { "mystic_image" }

    transient { user { create(:user, :with_balance) } }

    command_request { create(:command_prompt_to_image_request, user:) }
    parent_request { create(:prompt_message, command_request:) }

    trait :completed do
      status { "COMPLETED" }
      image_url { "http://example.com/image.png" }
    end

    trait :no_cost do
      processor { "imagen_image" }
    end
  end
end
