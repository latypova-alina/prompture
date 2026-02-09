FactoryBot.define do
  factory :button_image_processing_request do
    status { "PENDING" }
    image_url { nil }
    processor { "mystic" }

    association :command_request, factory: :command_prompt_to_image_request
    association :parent_request, factory: :button_extend_prompt_request

    trait :completed do
      status { "COMPLETED" }
      image_url { "http://example.com/image.png" }
    end
  end
end
