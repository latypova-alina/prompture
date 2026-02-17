FactoryBot.define do
  factory :user do
    chat_id { 456 }
    name { "Rihanna" }
  end

  trait :with_balance do
    after(:create) do |user|
      create(:balance, user:, credits: 100)
    end
  end
end
