module Generator
  module Media
    module CreateTask
      class InterimMessageSender
        include LocaleSupport

        def self.call(request:)
          new(request:).call
        end

        def initialize(request:)
          @request = request
        end

        def call
          with_locale(request.locale) do
            response = Telegram.bot.send_message(chat_id: request.chat_id, **message_payload)
            tg_message_id = response.dig("result", "message_id")
            request.update!(interim_tg_message_id: tg_message_id)
          end
        end

        private

        attr_reader :request

        def message_payload
          {
            text: I18n.t("errors.media_generating_interim"),
            reply_markup: { inline_keyboard: buttons }
          }
        end

        def buttons
          [[
            {
              text: I18n.t("errors.check_status_button"),
              callback_data: "#{ButtonActions::CHECK_GENERATION_STATUS}:#{request.id}:#{request.class.name}"
            },
            {
              text: I18n.t("errors.cancel_generation_button"),
              callback_data: "#{ButtonActions::CANCEL_GENERATION}:#{request.id}:#{request.class.name}"
            }
          ]]
        end
      end
    end
  end
end
