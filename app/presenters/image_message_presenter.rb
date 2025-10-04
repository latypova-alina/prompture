class ImageMessagePresenter
  include MessageInterface

  def initialize(message, button_request)
    @message = message
    @button_request = button_request
  end

  def formatted_text
    "<a href=\"#{message}\">Open image</a>"
  end

  def inline_keyboard
    #TODO update to have "regenerate"
    Buttons::ForPromptMessage.buttons
  end

  private

  attr_reader :message, :button_request
end
