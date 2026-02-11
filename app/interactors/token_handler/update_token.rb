module TokenHandler
  class UpdateToken
    include Interactor
    include Memoist

    delegate :token, :user, to: :context

    def call
      token.update!(used: true, used_at: Time.current, user:)
    end
  end
end
