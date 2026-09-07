module MiniApp
  module BuyStones
    class AcceptTerms
      include Interactor

      delegate :user, :terms_accepted, to: :context

      def call
        return unless terms_accepted
        return if user.terms_accepted_at.present?

        user.update!(terms_accepted_at: Time.current)
      end
    end
  end
end
