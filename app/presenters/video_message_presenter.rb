class VideoMessagePresenter
  include MessageInterface

  def initialize(message, button_request)
    @message = message
    @button_request = button_request
  end

  def formatted_text
    "<a href=\"#{message}\">Open video</a>"
  end

  def inline_keyboard
    Buttons::ForVideoMessage.buttons
  end

  private

  attr_reader :message, :button_request
end
