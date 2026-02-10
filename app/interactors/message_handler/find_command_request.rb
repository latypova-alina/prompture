module MessageHandler
  class FindCommandRequest
    include Interactor
    include Memery

    delegate :chat_id, :command, to: :context

    COMMAND_REQUESTS = {
      "prompt_to_image" => CommandPromptToImageRequest,
      "prompt_to_video" => CommandPromptToVideoRequest,
      "image_to_video" => CommandImageToVideoRequest,
      "image_from_reference" => CommandImageFromReferenceRequest
    }.freeze

    def call
      context.fail!(error: CommandUnknownError) unless command_request_class
      context.fail!(error: CommandRequestForgottenError) unless command_request

      context.command_request = command_request
    end

    private

    memoize def command_request
      command_request_class.where(chat_id:).order(created_at: :desc).first
    end

    def command_request_class
      COMMAND_REQUESTS[command]
    end
  end
end
