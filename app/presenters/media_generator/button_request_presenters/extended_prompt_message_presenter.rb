module ButtonRequestPresenters
  class ExtendedPromptMessagePresenter < BasePresenter
    include MessageInterface

    def formatted_text
      message
    end

    def inline_keyboard
      Buttons::ForExtendedPromptMessage.build
    end
  end
end
