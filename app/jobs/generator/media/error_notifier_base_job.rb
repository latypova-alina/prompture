module Generator
  module Media
    module Image
      class ErrorNotifierBaseJob < ApplicationJob
        include Memery

        def perform(button_request_id)
          @button_request_id = button_request_id

          with_locale(locale) do
            Telegram.bot.send_message(
              chat_id:,
              text: I18n.t("errors.image_generating_error")
            )
          end

          request.update!(status: "FAILED")
        end

        private

        attr_reader :button_request_id

        delegate :chat_id, to: :request

        def error_text
          raise NotImplementedError
        end

        def request_class
          raise NotImplementedError
        end

        memoize def request
          request_class.includes(:parent_request, command_request: :user).find(button_request_id)
        end
      end
    end
  end
end
