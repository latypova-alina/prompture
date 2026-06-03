module MediaGenerator
  module ButtonHandler
    class RequestVideoPrompt
      include Interactor

      delegate :command_request, :callback_query_id, to: :context

      def call
        send_prompt_request_message
        answer_callback_query
      end

      private

      def send_prompt_request_message
        Telegram.bot.send_message(
          chat_id: command_request.chat_id,
          text: I18n.t("telegram_webhooks.message.image_to_video_prompt_reply", locale:)
        )
      end

      def answer_callback_query
        return if callback_query_id.blank?

        Telegram.bot.answer_callback_query(callback_query_id:)
      end

      def locale
        command_request.user.locale
      end
    end
  end
end
