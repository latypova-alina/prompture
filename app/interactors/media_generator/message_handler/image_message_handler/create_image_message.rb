module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class CreateImageMessage
        include Interactor

        delegate :image_url, :command_request, to: :context

        def call
          context.image_message = ImageMessage.create!(
            image_url:,
            parent_request: command_request,
            command_request:
          )
        end
      end
    end
  end
end
