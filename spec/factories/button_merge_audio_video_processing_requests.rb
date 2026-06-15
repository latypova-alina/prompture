FactoryBot.define do
  factory :button_merge_audio_video_processing_request do
    status { "PENDING" }
    processor { "local_ffmpeg_merge" }
    source_video_url { "https://example.com/video.mp4" }
    source_audio_url { "https://example.com/audio.mp3" }
    association :parent_request, factory: :button_audio_processing_request
    association :command_request, factory: :command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT
  end
end
