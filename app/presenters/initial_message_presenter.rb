class InitialMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    I18n.t("telegram_webhooks.message.prompt_prefix") + "\n\n" +
    message + "\n\n" +
    I18n.t("telegram_webhooks.message.prompt_suffix")
  end

  def inline_keyboard
    Buttons::ForInitialMessage.buttons
  end

  private

  attr_reader :message
end
