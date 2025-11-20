class ImageMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    "<a href=\"#{message}\">Open image</a>"
  end

  def inline_keyboard
    Buttons::ForImageMessage.buttons
  end

  private

  attr_reader :message
end
