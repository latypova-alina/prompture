module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class ForPromptToVideo < BasePresenter
        include MessageInterface
        def initialize(balance:, processor_name:, **kwargs)
          super(**kwargs)
          @balance = balance
          @processor_name = processor_name
        end

        def formatted_text
          <<~HTML
            #{I18n.t("telegram_webhooks.message.image_generated_prefix", processor_name:, locale:)}

            <a href="#{message}">#{I18n.t('telegram_webhooks.message.image_processed', locale:)}</a>

            ────────────
            #{I18n.t('telegram_webhooks.commands.balance', balance:, locale:)}
          HTML
        end

        def inline_keyboard
          Buttons::ForImageMessage::ForPromptToVideo.build(locale:)
        end

        private

        attr_reader :balance, :processor_name
      end
    end
  end
end
