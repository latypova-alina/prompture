module CommandRequestPresenters
  class PromptRequestPresenter
    include MessageInterface

    def initialize(command_request)
      @command_request = command_request
    end

    def formatted_text
      <<~HTML
        #{I18n.t('telegram_webhooks.message.prompt_prefix')}

        <blockquote>#{prompt}</blockquote>

        #{I18n.t('telegram_webhooks.message.prompt_suffix')}
      HTML
    end

    def inline_keyboard
      Buttons::ForInitialPromptMessage::BUTTONS
    end

    private

    attr_reader :command_request

    delegate :prompt, to: :command_request
  end
end
