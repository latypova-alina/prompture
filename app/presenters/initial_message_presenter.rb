class InitialMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    <<~TEXT
      #{I18n.t('telegram_webhooks.message.prompt_prefix')}

      #{message}

      #{I18n.t('telegram_webhooks.message.prompt_suffix')}
    TEXT
  end

  def inline_keyboard
    Buttons::ForInitialMessage.buttons
  end

  private

  attr_reader :message
end
