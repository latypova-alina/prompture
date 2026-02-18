module TokenHandler
  class VerifyToken
    include Interactor
    include Memery

    delegate :token_code, to: :context

    def call
      validate_token!

      context.token = token
    end

    private

    def validate_token!
      context.fail!(error: TokenNotFoundError) unless token
      context.fail!(error: TokenUsedError) if token.used_at.present?
      context.fail!(error: TokenExpiredError) if token.expired?
    end

    memoize def token
      Token.find_by(code: token_code)
    end
  end
end
