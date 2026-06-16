module MediaGenerator
  module ButtonHandler
    class CheckGenerationStatus
      include Interactor
      include Memery
      include LocaleSupport

      delegate :button_request, :callback_query_id, to: :context

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

      delegate :locale, to: :generation_request
      delegate :status_text, to: :status_resolver

      memoize def status_resolver
        Generator::Media::FalStatusResolver.new(generation_request)
      end

      memoize def generation_request
        request_id, request_type = button_request.split(":").last(2)

        request_type.constantize.find(request_id)
      end
    end
  end
end
