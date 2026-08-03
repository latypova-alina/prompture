FactoryBot.define do
  factory :stars_purchase do
    sequence(:telegram_payment_charge_id) { |n| "charge_#{n}" }
    pack_key { "medium" }
    stars_amount { 450 }
    credits_amount { 100 }
    user
  end
end
