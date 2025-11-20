class ButtonMessagePresenter < BasePresenter
  include Memery

  PRESENTER_CLASSES = {
    "image_message" => ::ImageMessagePresenter,
    "video_message" => ::VideoMessagePresenter
  }.freeze

  def initialize(message, message_type)
    super()
    @message = message
    @message_type = message_type
  end

  private

  attr_reader :message, :message_type

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class

  memoize def corresponding_class
    PRESENTER_CLASSES[message_type].new(message)
  end
end
