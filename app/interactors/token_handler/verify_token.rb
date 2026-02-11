module TokenHandler
  class VerifyToken
    include Interactor
    include Memoist

    delegate :token_code, to: :context

    def call
      context.fail!(error: TokenNotFoundError) unless token

      context.token = token
    end

    private

    memoize def token
      Token.find_by(code: token_code)
    end
  end
end
