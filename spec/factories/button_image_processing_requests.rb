FactoryBot.define do
  factory :button_image_processing_request do
    status { "PENDING" }
    image_url { nil }
    processor { "mystic_image" }

    parent_request { command_request }

    transient { user { create(:user, :with_balance) } }

    command_request { create(:command_prompt_to_image_request, user:) }

    trait :completed do
      status { "COMPLETED" }
      image_url { "http://example.com/image.png" }
    end

    trait :no_cost do
      processor { "imagen_image" }
    end
  end
end
