FactoryBot.define do
  factory :stored_image do
    image_url { "https://internal-bucket.example.com/images/sample.png" }
    association :source_message, factory: :user_image_url_message
  end
end
