module SetLocale
  module CommandHandler
    class UpdateUser
      include Interactor
      include Memery

      delegate :locale, :chat_id, to: :context

      def call
        user.update(locale:)
      end

      private

      memoize def user
        User.find_by!(chat_id:)
      end
    end
  end
end
