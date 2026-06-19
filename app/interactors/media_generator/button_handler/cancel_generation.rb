module MediaGenerator
  module ButtonHandler
    class CancelGeneration
      include Interactor
      include Memery
      include LocaleSupport

      delegate :button_request, :callback_query_id, to: :context

      def call
        with_locale(locale) do
          Generator::Media::Interim::CancellationHandler.call(
            generation_request:,
            callback_query_id:
          )
        end
      rescue StandardError
        Generator::Media::Interim::Notifier::Fail.call(
          generation_request:,
          callback_query_id:
        )
      end

      private

      delegate :locale, to: :generation_request

      memoize def generation_request
        request_id, request_type = button_request.split(":").last(2)

        request_type.constantize.find(request_id)
      end
    end
  end
end
