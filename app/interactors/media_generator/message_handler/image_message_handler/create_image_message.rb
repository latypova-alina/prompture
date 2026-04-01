module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class CreateImageMessage
        include Interactor
        include Memery

        delegate :url, :chat_id, :command_request, to: :context

        def call
          context.image_message = ImageMessage.create!(
            image_url: url,
            parent_request: command_request,
            command_request:
          )
        end
      end
    end
  end
end
