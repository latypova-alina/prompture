module TelegramIntegration
  module CallbackQuery
    class CallbackQueryDispatcher
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(button_request:, chat_id:, tg_message_id:, callback_query_id:)
        @button_request = button_request
        @chat_id = chat_id
        @tg_message_id = tg_message_id
        @callback_query_id = callback_query_id
      end

      def call
        return unless handled_button.failure?

        return notify_image_not_ready if image_not_ready_error?

        raise handled_button.error
      end

      private

      attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

      delegate :handled_button, to: :callback_button_handler

      def image_not_ready_error?
        handled_button.error == ImageNotReadyError
      end

      def notify_image_not_ready
        TelegramIntegration::SendAlertCallbackQuery.call(
          callback_query_id:,
          text: I18n.t("errors.image_not_ready")
        )
      end

      memoize def callback_button_handler
        CallbackButtonHandler.new(
          button_request:,
          chat_id:,
          tg_message_id:,
          callback_query_id:
        )
      end
    end
  end
end
