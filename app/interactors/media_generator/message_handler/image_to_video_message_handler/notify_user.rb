module MediaGenerator
  module MessageHandler
    module ImageToVideoMessageHandler
      class NotifyUser
        include Interactor

        delegate :prompt_message, to: :context

        def call
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data:,
            request: prompt_message
          )
        end

        private

        delegate :reply_data, to: :presenter

        def presenter
          MediaGenerator::UserMessage::ImageToVideo::PromptMessagePresenter.new(locale:)
        end

        def locale
          prompt_message.command_request.user.locale
        end
      end
    end
  end
end
