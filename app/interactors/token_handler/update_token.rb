module TokenHandler
  class UpdateToken
    include Interactor

    delegate :token, :user, to: :context

    def call
      token.update!(used_at: Time.current, user:)
    end
  end
end
