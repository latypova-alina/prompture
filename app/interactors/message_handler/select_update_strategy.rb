module MessageHandler
  class SelectUpdateStrategy
    include Interactor
    include Memery

    delegate :message_text, :chat_id, :picture_id, :command, to: :context

    HANDLERS = {
      "prompt_to_image" => ::RecordUpdaters::CommandRequests::PromptToImage,
      "prompt_to_video" => ::RecordUpdaters::CommandRequests::PromptToVideo,
      "image_to_video" => ::RecordUpdaters::CommandRequests::ImageToVideo,
      "image_from_reference" => ::RecordUpdaters::CommandRequests::ImageFromReference
    }.freeze

    def call
      context.fail!(error: CommandUnknownError) unless handler

      context.command_request = command_request
    rescue MessageTypeError, CommandRequestForgottenError => e
      context.fail!(error: e.class)
    end

    private

    delegate :command_request, to: :handler_result

    memoize def handler_result
      handler.new(message_text, chat_id, picture_id)
    end

    memoize def handler
      HANDLERS[command]
    end
  end
end
