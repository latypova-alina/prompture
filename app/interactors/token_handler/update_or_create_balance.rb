module TokenHandler
  class UpdateOrCreateBalance
    include Interactor
    include Memoist

    delegate :token, :user, to: :context

    def call
      balance.increment!(:credits, token.credits)
    end

    private

    memoize def balance
      Balance.find_or_create_by(user:) { |b| b.credits = 0 }
    end
  end
end
