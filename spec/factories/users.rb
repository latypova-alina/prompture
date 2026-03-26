FactoryBot.define do
  factory :user do
    sequence(:chat_id) { |n| 1000 + n }
    name { "Rihanna" }
  end

  trait :with_balance do
    after(:create) do |user|
      create(:balance, user:, credits: 100)
    end
  end

  trait :with_custom_balance do
    transient do
      credits { 100 }
    end

    after(:create) do |user, evaluator|
      create(:balance, user:, credits: evaluator.credits)
    end
  end
end
