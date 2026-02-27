module Generator
  module Video
    class ErrorNotifierJob < BaseNotifierJob
      include WithLocaleInterface

      def perform(button_request_id)
        @button_request_id = button_request_id

        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id:,
            text: I18n.t("errors.video_generating_error")
          )
        end

        request.update!(status: "FAILED")
      end

      private

      attr_reader :button_request_id

      delegate :chat_id, to: :request
    end
  end
end
