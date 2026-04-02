module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class NotifyUser
        include Interactor

        delegate :image_message, to: :context

        def call
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data:,
            request: image_message
          )
        end

        private

        delegate :reply_data, to: :presenter
        delegate :image_url, to: :image_message

        def presenter
          MediaGenerator::UserMessagePresenters::ImageMessagePresenter.new(message: image_url)
        end
      end
    end
  end
end
