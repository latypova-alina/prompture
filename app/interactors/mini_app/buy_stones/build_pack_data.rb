module MiniApp
  module BuyStones
    class BuildPackData
      include Interactor
      include Memery

      delegate :user, :locale, to: :context

      def call
        context.buy_button = I18n.t("mini_app.buy_stones.buy_button", locale:)
        context.terms_required = !terms_accepted?
        context.packs = pack_data_builder.pack_data
      end

      private

      def terms_accepted?
        user.terms_accepted_at.present?
      end

      memoize def pack_data_builder
        pack_data_builder_class.new(locale:, include_invoice: terms_accepted?)
      end

      def pack_data_builder_class
        return StarsPayment::TestPackDataBuilder if user.admin?

        StarsPayment::PackDataBuilder
      end
    end
  end
end
