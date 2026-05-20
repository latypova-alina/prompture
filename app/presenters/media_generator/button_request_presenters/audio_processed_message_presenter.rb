module MediaGenerator
  module ButtonRequestPresenters
    class AudioProcessedMessagePresenter < BasePresenter
      include MessageInterface

      def initialize(balance:, processor_name:, processor:, **kwargs)
        super(**kwargs)
        @balance = balance
        @processor_name = processor_name
        @processor = processor
      end

      def formatted_text
        <<~HTML
          #{I18n.t('telegram_webhooks.message.audio_generated_prefix', processor_name:, locale:)}

          <a href="#{message}">#{I18n.t('telegram_webhooks.message.audio_processed', locale:)}</a>

          ────────────
          #{I18n.t('telegram_webhooks.commands.balance', balance:, count: balance, locale:)}
        HTML
      end

      def inline_keyboard
        []
      end

      private

      attr_reader :balance, :processor_name, :processor
    end
  end
end
