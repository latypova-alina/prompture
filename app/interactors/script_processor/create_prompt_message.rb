module ScriptProcessor
  class CreatePromptMessage
    include Interactor

    delegate :script, :command_request, to: :context

    def call
      context.prompt_message = PromptMessage.create!(
        prompt: script,
        parent_request: command_request,
        command_request:
      )
    end
  end
end
