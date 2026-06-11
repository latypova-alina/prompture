FactoryBot.define do
  factory :button_audio_processing_request do
    status { "PENDING" }
    audio_url { nil }
    processor { "elevenlabs_v3_audio" }
    voice { "adam" }

    transient { user { create(:user, :with_balance) } }

    command_request { create(:command_prompt_to_audio_request, user:) }
    parent_request { create(:prompt_message, command_request:) }

    trait :completed do
      status { "COMPLETED" }
      audio_url { "http://example.com/audio.mp3" }
    end
  end
end
