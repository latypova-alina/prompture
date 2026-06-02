module MediaGenerator
  module UserMessage
    module ImageMessage
      class EditImagePromptRequestPresenter < ::BasePresenter
        include MessageInterface

        def formatted_text
          I18n.t("telegram_webhooks.message.edit_image_prompt_reply", locale:)
        end

        def inline_keyboard
          []
        end
      end
    end
  end
end
