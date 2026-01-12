class BasePresenter
  include Memery

  def initialize(message)
    @message = message
  end

  def reply_data
    {
      parse_mode: "HTML",
      text: formatted_text,
      reply_markup: { inline_keyboard: }
    }
  end

  private

  attr_reader :message

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class

  memoize def corresponding_class
    raise NotImplementedError
  end
end
