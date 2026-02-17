FactoryBot.define do
  factory :token do
    code { "XXX" }
    greeting { "Hello, Rihanna!" }
    credits { 100 }
    expires_at { 1.week.from_now }
  end

  trait :expired do
    expires_at { 1.week.ago }
  end

  trait :used do
    used_at { Time.current }
  end
end
