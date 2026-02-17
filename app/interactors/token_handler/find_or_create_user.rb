module TokenHandler
  class FindOrCreateUser
    include Interactor
    include Memery

    delegate :chat_id, :name, to: :context

    def call
      context.user = user
    end

    private

    memoize def user
      User.find_or_create_by(chat_id:) do |u|
        u.name = context.name || "User#{context.chat_id}"
      end
    end
  end
end
