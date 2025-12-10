module CommandRequestPresenters
  class PromptRequestPresenter
    include MessageInterface

    def initialize(message)
      @message = message
    end

    def formatted_text
      <<~HTML
        #{I18n.t('telegram_webhooks.message.prompt_prefix')}

        <blockquote>#{message}</blockquote>

        #{I18n.t('telegram_webhooks.message.prompt_suffix')}
      HTML
    end

    def inline_keyboard
      Buttons::ForInitialPromptMessage.buttons
    end

    private

    attr_reader :message
  end
end
