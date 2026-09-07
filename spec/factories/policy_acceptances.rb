FactoryBot.define do
  factory :policy_acceptance do
    user
    privacy_policy_version { POLICY_VERSIONS[:privacy_policy] }
    terms_version { POLICY_VERSIONS[:terms_of_use] }
    accepted_at { Time.current }
  end
end
