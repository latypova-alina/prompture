module ScriptProcessor
  class HandleImageGenerationButton
    include Interactor
    include Memery

    FLUX_BUTTON = "flux_image".freeze
    NANO_BANANA_BUTTON = "nano_banana_image".freeze

    IMAGE_BUTTON_BY_CATEGORY = {
      ContentCategory::CARTOON_CHARACTER => NANO_BANANA_BUTTON
    }.freeze

    delegate :chat_id, :prompt_message, to: :context

    def call
      context.fail!(error: ParentNotFoundError) if bot_message.blank?

      context.fail!(error: handled_button.error) if handled_button.failure?
    end

    private

    delegate :command_request, to: :prompt_message
    delegate :category, to: :command_request, allow_nil: true

    memoize def handled_button
      MediaGenerator::ButtonHandler::HandleButton.call(
        button_request: image_button,
        chat_id:,
        tg_message_id: bot_message.tg_message_id,
        callback_query_id: nil
      )
    end

    def image_button
      IMAGE_BUTTON_BY_CATEGORY.fetch(category, FLUX_BUTTON)
    end

    def bot_message
      prompt_message.reload.bot_telegram_message
    end
  end
end
