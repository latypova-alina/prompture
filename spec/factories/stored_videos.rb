FactoryBot.define do
  factory :stored_video do
    video_url { "https://internal.example/videos/motivation/cry/clip.mp4" }
    category { ContentCategory::MOTIVATION }
    subcategory { "cry" }
    prompt { "Close-up of tears falling in rain" }
    association :source, factory: :button_video_processing_request
  end
end
