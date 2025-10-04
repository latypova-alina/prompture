class BasePresenter
  include Memery

  def reply_data
    {
      parse_mode: "HTML",
      text: formatted_text,
      reply_markup: { inline_keyboard: }
    }
  end

  private

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class

  memoize def corresponding_class
    raise NotImplementedError
  end
end
