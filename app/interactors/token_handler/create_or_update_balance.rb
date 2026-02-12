module TokenHandler
  class CreateOrUpdateBalance
    include Interactor
    include Memery

    delegate :token, :user, to: :context
    delegate :credits, to: :token

    def call
      balance.increment!(:credits, credits)
    end

    private

    memoize def balance
      Balance.find_or_create_by(user:) { |b| b.credits = 0 }
    end
  end
end
