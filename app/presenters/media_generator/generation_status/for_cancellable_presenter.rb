module MediaGenerator
  module GenerationStatus
    class ForCancellablePresenter < BasePresenter
      INTERIM_MESSAGE_KEY = "errors.video_generating_interim".freeze

      def inline_keyboard
        [[check_status_button, cancel_button]]
      end

      def message_payload_text
        I18n.t(INTERIM_MESSAGE_KEY)
      end
    end
  end
end
