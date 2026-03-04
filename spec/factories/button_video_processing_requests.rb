FactoryBot.define do
  factory :button_video_processing_request do
    status { "PENDING" }
    video_url { nil }
    image_url { "http://example.com/image.png" }
    processor { "kling_2_1_pro_image_to_video" }

    association :parent_request, factory: :button_image_processing_request

    transient { user { create(:user, :with_balance) } }

    command_request { create(:command_prompt_to_video_request, user:) }

    trait :completed do
      status { "COMPLETED" }
      video_url { "http://example.com/video.mp4" }
    end
  end
end
