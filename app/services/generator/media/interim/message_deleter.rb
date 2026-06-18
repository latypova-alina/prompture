module Generator
  module Media
    module Interim
      class MessageDeleter
        def self.call(request:)
          new(request:).call
        end

        def initialize(request:)
          @request = request
        end

        def call
          return unless request.interim_tg_message_id

          TelegramIntegration::DeleteMessage.call(
            chat_id: request.chat_id,
            message_id: request.interim_tg_message_id
          )

          request.update!(interim_tg_message_id: nil)
        end

        private

        attr_reader :request
      end
    end
  end
end
