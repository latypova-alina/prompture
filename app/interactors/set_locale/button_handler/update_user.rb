module SetLocale
  module ButtonHandler
    class UpdateUser
      include Interactor
      include Memery

      delegate :selected_locale, :chat_id, to: :context

      def call
        user.update(locale: selected_locale)
      end

      private

      memoize def user
        User.find_by!(chat_id:)
      end
    end
  end
end
