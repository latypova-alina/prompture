class ImageMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    "#{message}\n\nHello, this is an image message!"
  end

  def inline_keyboard
    Buttons::ForPromptMessage.buttons
  end

  private

  attr_reader :message
end
