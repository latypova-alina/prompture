FactoryBot.define do
  factory :balance_transaction do
    amount { -10 }
    transaction_type { "CHARGE" }
    association :source, factory: :button_image_processing_request
    user

    trait :refund do
      amount { 10 }
      transaction_type { "REFUND" }
    end
  end
end
