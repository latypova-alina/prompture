module MiniApp
  class CurrentPolicyAcceptance
    include Memery

    def initialize(user:)
      @user = user
    end

    def present?
      return false unless latest_acceptance

      latest_acceptance.privacy_policy_version == POLICY_VERSIONS[:privacy_policy] &&
        latest_acceptance.terms_version == POLICY_VERSIONS[:terms_of_use]
    end

    private

    attr_reader :user

    memoize def latest_acceptance
      user.policy_acceptances.order(accepted_at: :desc).first
    end
  end
end
