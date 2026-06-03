module MediaGenerator
  module MessageHandler
    module ImageToVideoMessageHandler
      class CreatePromptMessage
        include Interactor

        delegate :message_text, :command_request, to: :context

        def call
          context.prompt_message = PromptMessage.create!(
            prompt: message_text,
            parent_request: command_request.latest_image_message,
            command_request:
          )

          command_request.update!(awaiting_video_prompt: false)
        end
      end
    end
  end
end
