class ButtonMessagePresenter < BasePresenter
  include Memery

  PRESENTER_CLASSES = {
    "image_message" => ::ImageMessagePresenter
  }.freeze

  def initialize(message, message_type, button_request, regenerate = false)
    super()
    @message = message
    @message_type = message_type
    @button_request = button_request
    @regenerate = regenerate
  end

  private

  attr_reader :message, :message_type, :button_request, :regenerate

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class

  memoize def corresponding_class
    PRESENTER_CLASSES[message_type].new(message, button_request, regenerate)
  end
end
