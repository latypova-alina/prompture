module MessageHandler
  class SelectUpdateStrategy
    include Interactor
    include Memery

    delegate :message_text, :chat_id, :picture_id, :command, to: :context

    HANDLERS = {
      "prompt_to_image" => UpdateCommandRequest::PromptToImage,
      "prompt_to_video" => UpdateCommandRequest::PromptToVideo,
      "image_to_video" => UpdateCommandRequest::ImageToVideo,
      "image_from_reference" => UpdateCommandRequest::ImageFromReference
    }.freeze

    def call
      context.fail!(error: CommandUnknownError) unless handler
      context.fail!(error: handler_result.context.error) if handler_result.failure?

      context.command_request = command_request
    end

    private

    delegate :command_request, to: :handler_result

    memoize def handler_result
      handler.call(
        message_text:,
        chat_id:,
        picture_id:
      )
    end

    def handler
      HANDLERS[command]
    end
  end
end
