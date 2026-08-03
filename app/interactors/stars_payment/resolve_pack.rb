module StarsPayment
  class ResolvePack
    include Interactor
    include Memery

    delegate :pack_key, to: :context

    def call
      context.fail!(error: PackNotFoundError) unless pack

      context.pack = pack
    end

    private

    memoize def pack
      CREDIT_PACKS[pack_key.to_sym]
    end
  end
end
