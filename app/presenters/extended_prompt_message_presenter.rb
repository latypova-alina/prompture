class ExtendedPromptMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    message
  end

  def inline_keyboard
    Buttons::ForExtendedPromptMessage.buttons
  end

  private

  attr_reader :message
end
