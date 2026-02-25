module Buttons
  class ForInitialPromptMessage < Base
    def build
      [
        [extend_prompt_button],
        *build_processors_for_media
      ]
    end

    private

    def extend_prompt_button
      {
        text: I18n.t("telegram_webhooks.message.buttons.extend_prompt"),
        callback_data: "extend_prompt"
      }
    end

    def scope
      "generate_image"
    end

    def type
      :images
    end
  end
end
