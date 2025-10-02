class MessagePresenter
  include Memery

  PRESENTER_CLASSES = {
    "prompt_message" => ::PromptMessagePresenter,
    "image_message" => ::ImageMessagePresenter
  }.freeze

  def initialize(message, data)
    @message = message
    @data = data
  end

  def reply_data
    {
      parse_mode: "HTML",
      text: formatted_text,
      reply_markup: { inline_keyboard: }
    }
  end

  private

  attr_reader :message, :data

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class
  delegate :message_type, :button_request, to: :message_data

  memoize def corresponding_class
    PRESENTER_CLASSES[message_type].new(message)
  end

  def message_data
    MessageData.new(**data)
  end
end
