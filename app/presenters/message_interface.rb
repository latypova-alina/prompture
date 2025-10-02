module MessageInterface
  def formatted_text
    raise NotImplementedError
  end

  def inline_keyboard
    raise NotImplementedError
  end
end
