module MediaGenerator
  module GenerationStatus
    class BasePresenter
      def initialize(request)
        @request = request
      end

      def message_payload_text
        raise NotImplementedError
      end

      def inline_keyboard
        raise NotImplementedError
      end

      private

      attr_reader :request

      def check_status_button
        {
          text: I18n.t("errors.check_status_button"),
          callback_data: "#{ButtonActions::CHECK_GENERATION_STATUS}:#{request.id}:#{request.class.name}"
        }
      end

      def cancel_button
        {
          text: I18n.t("errors.cancel_generation_button"),
          callback_data: "#{ButtonActions::CANCEL_GENERATION}:#{request.id}:#{request.class.name}"
        }
      end
    end
  end
end
