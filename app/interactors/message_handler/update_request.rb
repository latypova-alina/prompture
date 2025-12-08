module MessageHandler
  class UpsertRequest
    include Interactor
    include Memery

    delegate :message_text, :chat_id, :picture_id, :command, to: :context

    HANDLERS = {
      "prompt_to_image" => CommandPromptToImageRequest::Update,
      "prompt_to_video" => CommandPromptToVideoRequest::Update,
      "image_to_video" => CommandImageToVideoRequest::Update,
      "image_from_reference" => CommandImageFromReferenceRequest::Update
    }.freeze

    def call
      handler = HANDLERS[command]

      return handler.call(message_text:, chat_id:, picture_id:) if handler

      context.fail!(error: CommandUnknownError)
    end
  end
end
