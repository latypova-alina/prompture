FactoryBot.define do
  factory :button_video_processing_request do
    status { "PENDING" }
    video_url { nil }
    processor { "kling_2_1_pro_image_to_video" }

    association :command_request, factory: :command_prompt_to_video_request
    association :parent_request, factory: :button_image_processing_request

    trait :completed do
      status { "COMPLETED" }
      video_url { "http://example.com/video.mp4" }
    end
  end
end
