module MediaGenerator
  module ButtonRequestPresenters
    class VideoProcessedMessagePresenter < BasePresenter
      include MessageInterface
      def initialize(balance:, processor_name:, **kwargs)
        super(**kwargs)
        @balance = balance
        @processor_name = processor_name
      end

      def formatted_text
        <<~HTML
          #{I18n.t("telegram_webhooks.message.video_generated_prefix", processor_name:, locale:)}

          <a href="#{message}">#{I18n.t('telegram_webhooks.message.video_processed', locale:)}</a>

          ────────────
          #{I18n.t('telegram_webhooks.commands.balance', balance:, count: balance, locale:)}
        HTML
      end

      def inline_keyboard
        Buttons::ForVideoMessage.build(locale:)
      end

      private

      attr_reader :balance, :processor_name
    end
  end
end
