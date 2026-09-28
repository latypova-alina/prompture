module TermsGate
  class FindUser
    include Interactor

    delegate :chat_id, to: :context

    def call
      context.user = User.find_by(chat_id:)
      context.terms_accepted = true
    end
  end
end
