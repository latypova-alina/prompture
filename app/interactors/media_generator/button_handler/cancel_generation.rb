module MediaGenerator
  module ButtonHandler
    class CancelGeneration
      include LocaleSupport

      def self.call(button_request:, chat_id:, callback_query_id:)
        new(button_request:, chat_id:, callback_query_id:).call
      end

      def initialize(button_request:, chat_id:, callback_query_id:)
        @button_request = button_request
        @chat_id = chat_id
        @callback_query_id = callback_query_id
      end

      def call
        with_locale(locale) do
          cancel_fal_request
          answer_callback_query
        end
      end

      private

      attr_reader :button_request, :chat_id, :callback_query_id

      delegate :locale, to: :request

      def cancel_fal_request
        client = Generator::Media::FalRequestClient.new(request)
        response = client.cancel

        if response.success?
          request.update!(status: "CANCELLED")
          delete_interim_message
          notify_user(I18n.t("errors.generation_cancelled"))
        else
          notify_user(I18n.t("errors.generation_cancel_failed"))
        end
      rescue StandardError
        notify_user(I18n.t("errors.generation_cancel_failed"))
      end

      def delete_interim_message
        return unless request.interim_tg_message_id

        Telegram.bot.delete_message(
          chat_id: request.chat_id,
          message_id: request.interim_tg_message_id
        )
      end

      def answer_callback_query
        Telegram.bot.answer_callback_query(callback_query_id:)
      end

      def notify_user(text)
        Telegram.bot.send_message(chat_id: request.chat_id, text:)
      end

      def request
        @request ||= resolve_request
      end

      def resolve_request
        request_id, request_type = button_request.split(":").last(2)
        request_type.constantize.find(request_id)
      end
    end
  end
end
