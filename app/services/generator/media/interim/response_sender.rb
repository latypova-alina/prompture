module Generator
  module Media
    module Interim
      class ResponseSender
        include Memery

        def initialize(request:)
          @request = request
        end

        def tg_message_id
          response.dig("result", "message_id")
        end

        private

        attr_reader :request

        delegate :inline_keyboard, to: :presenter

        memoize def presenter
          MediaGenerator::GenerationStatusPresenter.new(request)
        end

        memoize def response
          Telegram.bot.send_message(chat_id: request.chat_id, **message_payload)
        end

        def message_payload
          {
            text: I18n.t("errors.media_generating_interim"),
            reply_markup: { inline_keyboard: }
          }
        end
      end
    end
  end
end
