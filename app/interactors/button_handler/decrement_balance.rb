module ButtonHandler
  class DecrementBalance
    include Interactor
    include Memery

    delegate :chat_id, :button_request_record, to: :context
    delegate :balance, to: :user
    delegate :cost, to: :button_request_record

    def call
      balance.with_lock do
        context.fail!(error: InsufficientCreditsError) if balance.credits < cost

        balance.decrement!(:credits, cost)
      end
    end

    private

    memoize def user
      User.find_by!(chat_id:)
    end
  end
end
