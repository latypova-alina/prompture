module MediaGenerator
  module ButtonRequestPresenters
    class VideoProcessedMessagePresenter < BasePresenter
      include MessageInterface
      def initialize(balance:, **kwargs)
        super(**kwargs)
        @balance = balance
      end

      def formatted_text
        <<~HTML
          <a href="#{message}">#{I18n.t('telegram_webhooks.message.video_processed', locale:)}</a>

          ────────────
          #{I18n.t('telegram_webhooks.commands.balance', balance:, locale:)}
        HTML
      end

      def inline_keyboard
        Buttons::ForVideoMessage.build(locale:)
      end

      private

      attr_reader :balance
    end
  end
end
