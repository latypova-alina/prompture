module MessageHandler
  class CreatePromptMessage
    include Interactor
    include Memery

    delegate :message_text, :chat_id, :command_request, to: :context

    def call
      context.prompt_message = PromptMessage.create!(
        prompt: message_text,
        parent_request: command_request,
        command_request:
      )
    end
  end
end
