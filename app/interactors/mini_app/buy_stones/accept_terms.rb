module MiniApp
  module BuyStones
    class AcceptTerms
      include Interactor

      delegate :user, :terms_accepted, to: :context

      def call
        return unless terms_accepted
        return if current_policy_acceptance.present?

        user.policy_acceptances.create!(
          privacy_policy_version: POLICY_VERSIONS[:privacy_policy],
          terms_version: POLICY_VERSIONS[:terms_of_use],
          accepted_at: Time.current
        )
      end

      private

      def current_policy_acceptance
        MiniApp::CurrentPolicyAcceptance.new(user:)
      end
    end
  end
end
