FactoryBot.define do
  factory :button_video_processing_request do
    status { "PENDING" }
    video_url { nil }
    image_url { "http://example.com/image.png" }
    processor { "kling_2_1_pro_image_to_video" }

    association :command_request, factory: :command_prompt_to_video_request
    association :parent_request, factory: :button_image_processing_request

    trait :completed do
      status { "COMPLETED" }
      video_url { "http://example.com/video.mp4" }
    end

    trait :belonging_to_user do
      transient { user { create(:user, :with_balance) } }

      command_request { create(:command_prompt_to_video_request, user:) }
    end
  end
end
