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

        def presenter
          MediaGenerator::UserMessagePresenters::ImageMessagePresenter.new
        end
      end
    end
  end
end
