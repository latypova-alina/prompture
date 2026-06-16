module MediaGenerator
  module ButtonHandler
    class CheckGenerationStatus
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
          Telegram.bot.answer_callback_query(
            callback_query_id:,
            text: status_text,
            show_alert: true
          )
        end
      end

      private

      attr_reader :button_request, :chat_id, :callback_query_id

      delegate :locale, to: :request

      def status_text
        case fal_status
        when "IN_QUEUE", "IN_PROGRESS"
          I18n.t("errors.generation_status_in_progress")
        when "COMPLETED"
          I18n.t("errors.generation_status_completed")
        when "FAILED"
          I18n.t("errors.generation_status_failed")
        else
          I18n.t("errors.generation_status_unknown")
        end
      end

      def fal_status
        Generator::Media::FalRequestClient.new(request).status
      rescue StandardError
        nil
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
