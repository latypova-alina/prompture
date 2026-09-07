module MiniApp
  module BuyStones
    class ResolveUser
      include Interactor
      include Memery

      delegate :init_data, to: :context

      def call
        context.user = user
        context.locale = locale
      end

      private

      delegate :user_id, :user_name, to: :parser
      delegate :user, to: :user_resolver

      memoize def parser
        MiniApp::InitDataParser.new(init_data:)
      end

      memoize def user_resolver
        UserResolver.new(chat_id: user_id, name: user_name, locale: I18n.default_locale.to_s)
      end

      def locale
        Rails.application.config.x.supported_locales.include?(user.locale) ? user.locale : I18n.default_locale.to_s
      end
    end
  end
end
