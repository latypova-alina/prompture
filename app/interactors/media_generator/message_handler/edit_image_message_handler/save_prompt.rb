module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class SavePrompt
        include Interactor

        delegate :message_text, :command_request, to: :context

        def call
          command_request.update!(prompt: message_text)
        end
      end
    end
  end
end
