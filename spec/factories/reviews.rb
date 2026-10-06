FactoryBot.define do
  factory :review do
    user
    rating { 5 }
    survey_version { 1 }
    locale { "en" }
    answers do
      {
        "rating" => 5,
        "use_cases" => { "selected" => %w[social_media] },
        "features" => { "selected" => %w[video] },
        "missing" => "more voices for the audio feature",
        "frustrations" => "video generation can be slow at times"
      }
    end
  end
end
