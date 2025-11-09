class VideoMessagePresenter
  include MessageInterface

  def initialize(message)
    @message = message
  end

  def formatted_text
    "<a href=\"#{message}\">Open video</a>"
  end

  def inline_keyboard
    Buttons::ForVideoMessage.buttons
  end

  private

  attr_reader :message
end
