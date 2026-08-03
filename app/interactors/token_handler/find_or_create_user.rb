module TokenHandler
  class FindOrCreateUser
    include Interactor

    delegate :chat_id, :name, :locale, to: :context
    delegate :user, to: :resolver

    def call
      context.user = user
    end

    private

    def resolver
      UserResolver.new(chat_id:, name:, locale:)
    end
  end
end
