FactoryBot.define do
  factory :chat_event do
    sequence(:chat_id) { |n| 10_000 + n }
    direction { "incoming" }
    kind { "message" }
    occurred_at { Time.current }
    payload { {} }
  end
end
