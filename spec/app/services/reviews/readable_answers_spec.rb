require "rails_helper"

describe Reviews::ReadableAnswers do
  subject { described_class.call(review) }

  let(:review) do
    build(:review, rating: 3, answers: {
            "rating" => 3,
            "use_cases" => { "selected" => %w[work other], "other" => "school projects with my kids" },
            "features" => { "selected" => %w[audio] },
            "missing" => "more languages for voices",
            "frustrations" => "the queue is too slow sometimes"
          })
  end

  it do
    is_expected.to eq([
                        ["How would you rate the bot overall?", "⭐⭐⭐ 3/5"],
                        ["What do you use the bot for?", "Work or business, Other: school projects with my kids"],
                        ["Which features do you use most?", "Audio and voice"],
                        ["What's missing in the bot?", "more languages for voices"],
                        ["What doesn't satisfy you or annoys you?", "the queue is too slow sometimes"]
                      ])
  end
end
