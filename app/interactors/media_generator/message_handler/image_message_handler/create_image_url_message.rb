module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class CreateImageUrlMessage
        include Interactor

        delegate :image_url, :command_request, :tg_message_id, to: :context

        def call
          context.image_url_message = image_url.nil? ? nil : create_image_url_message
        end

        private

        def create_image_url_message
          ImageUrlMessage.create!(
            image_url:,
            tg_message_id:,
            parent_request: command_request,
            command_request:
          )
        end
      end
    end
  end
end
