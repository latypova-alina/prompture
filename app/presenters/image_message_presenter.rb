class ImageMessagePresenter
  include MessageInterface

  def initialize(message, button_request, regenerate = false)
    @message = message
    @button_request = button_request
    @regenerate = regenerate
  end

  def formatted_text
    "<a href=\"#{message}\">Open image</a>"
  end

  def inline_keyboard
    Buttons::ForImageMessage.buttons unless regenerate

    Buttons::ForRepeatedImageMessage.buttons
  end

  private

  attr_reader :message, :button_request, :regenerate
end
