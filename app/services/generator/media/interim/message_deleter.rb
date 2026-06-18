module Generator
  module Media
    module Interim
      class MessageDeleter
        INTERIM_PROCESSORS = (
          Generator::Processors::ALL_IMAGE + Generator::Processors::VIDEO
        ).freeze

        def self.call(request:)
          new(request:).call
        end

        def self.call_for_webhook(processor:, button_request_id:)
          return unless INTERIM_PROCESSORS.include?(processor)

          call(request: request_class(processor).find(button_request_id))
        end

        def self.request_class(processor)
          if Generator::Processors::ALL_IMAGE.include?(processor)
            ButtonImageProcessingRequest
          else
            ButtonVideoProcessingRequest
          end
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
