module UserMessagePresenters
  class PromptMessagePresenter
    include MessageInterface

    def initialize(prompt_message)
      @prompt_message = prompt_message
    end

    def formatted_text
      <<~HTML
        #{I18n.t('telegram_webhooks.message.prompt_prefix')}

        <blockquote>#{prompt}</blockquote>

        #{I18n.t('telegram_webhooks.message.prompt_suffix')}
      HTML
    end

    def inline_keyboard
      Buttons::ForInitialPromptMessage.build
    end

    private

    attr_reader :prompt_message

    delegate :prompt, to: :prompt_message
  end
end
