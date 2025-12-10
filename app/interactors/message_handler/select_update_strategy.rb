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
      handler = HANDLERS[command]

      return handler.call(message_text:, chat_id:, picture_id:) if handler

      context.fail!(error: CommandUnknownError)
    end
  end
end
