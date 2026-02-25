FactoryBot.define do
  factory :balance do
    credits { 100 }
    association :user
  end
end
