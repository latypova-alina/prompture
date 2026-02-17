FactoryBot.define do
  factory :button_image_processing_request do
    status { "PENDING" }
    image_url { nil }
    processor { "mystic_image" }

    association :command_request, factory: :command_prompt_to_image_request
    parent_request { command_request }

    trait :completed do
      status { "COMPLETED" }
      image_url { "http://example.com/image.png" }
    end

    trait :no_cost do
      processor { "imagen_image" }
    end
  end
end
