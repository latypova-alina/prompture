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
          return unless interim_tg_message_id

          TelegramIntegration::DeleteMessage.call(
            chat_id:,
            message_id: interim_tg_message_id
          )

          request.update!(interim_tg_message_id: nil)
        end

        private

        attr_reader :request

        delegate :interim_tg_message_id, :chat_id, to: :request
      end
    end
  end
end
