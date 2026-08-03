module StarsPayment
  class RecordPurchase
    include Interactor
    include Memery

    delegate :user, :pack, :pack_key, :telegram_payment_charge_id, :stars_amount, to: :context

    def call
      context.stars_purchase = purchase
      context.newly_recorded = purchase.previously_new_record?
    end

    private

    memoize def purchase
      StarsPurchase.find_or_create_by!(telegram_payment_charge_id:) do |sp|
        sp.user = user
        sp.pack_key = pack_key
        sp.stars_amount = stars_amount
        sp.credits_amount = pack[:credits]
      end
    end
  end
end
