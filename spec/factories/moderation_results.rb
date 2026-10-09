FactoryBot.define do
  factory :moderation_result do
    association :command_request, factory: :command_prompt_to_image_request
    input_kind { "text" }
    input_text { "cute white kitten" }
    model { "omni-moderation-latest" }
    blocked { false }
    openai_flagged { false }
    result { { "flagged" => false, "category_scores" => { "violence" => 0.01 } } }

    trait :blocked do
      blocked { true }
      blocked_by { "violence_score" }
      openai_flagged { true }
      result { { "flagged" => true, "category_scores" => { "violence" => 0.9 } } }
    end
  end
end
