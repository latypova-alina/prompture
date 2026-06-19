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

        delegate :presenter, to: :presenter_selector
        delegate :inline_keyboard, :message_payload_text, to: :presenter
        delegate :origin_telegram_message_id, to: :request

        memoize def presenter_selector
          MediaGenerator::GenerationStatus::PresenterSelector.new(request:)
        end

        memoize def response
          Telegram.bot.send_message(chat_id: request.chat_id, **message_payload)
        end

        def message_payload
          {
            text: message_payload_text,
            reply_markup: { inline_keyboard: },
            reply_to_message_id: origin_telegram_message_id
          }.compact
        end
      end
    end
  end
end
