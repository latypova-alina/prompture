module MediaGenerator
  module ButtonRequestPresenters
    class ExtendedPromptMessagePresenter < BasePresenter
      include MessageInterface
      def initialize(balance:, **kwargs)
        super(**kwargs)
        @balance = balance
      end

      def formatted_text
        <<~TEXT
          #{I18n.t('telegram_webhooks.message.extended_prompt_prefix', locale:)}
          ────────────
          #{message}

          ────────────
          #{I18n.t('telegram_webhooks.commands.balance', balance:, locale:)}
        TEXT
      end

      def inline_keyboard
        Buttons::ForExtendedPromptMessage.build(locale:)
      end

      private

      attr_reader :balance
    end
  end
end
