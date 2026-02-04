module ButtonHandler
  class FindCommandRequest
    include Interactor
    include Memery

    COMMAND_REQUESTS = {
      "prompt_to_image" => CommandPromptToImageRequest,
      "prompt_to_video" => CommandPromptToVideoRequest
    }.freeze

    delegate :command, :chat_id, to: :context

    def call
      context.fail!(error: CommandRequestForgottenError) unless command_request

      context.command_request = command_request
    end

    private

    memoize def command_request
      COMMAND_REQUESTS[command].where(chat_id:).order(created_at: :desc).first
    end
  end
end
