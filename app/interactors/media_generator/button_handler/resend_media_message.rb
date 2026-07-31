module MediaGenerator
  module ButtonHandler
    class ResendMediaMessage
      include Interactor

      delegate :parent_request, :callback_query_id, to: :context, private: true
      delegate :chat_id, :resolved_media_url, to: :parent_request, private: true

      def call
        Telegram.bot.send_message(chat_id:, text: resolved_media_url)
        Telegram.bot.answer_callback_query(callback_query_id:)
      end
    end
  end
end
