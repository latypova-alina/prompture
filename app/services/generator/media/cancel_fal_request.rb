module Generator
  module Media
    class CancelFalRequest
      def initialize(request)
        @request = request
      end

      def call
        return unless success?

        request.update!(status: "CANCELLED")

        delete_interim_message
      end

      delegate :success?, to: :response

      private

      attr_reader :request

      delegate :chat_id, :interim_tg_message_id, to: :request

      def response
        FalRequestClient.new(request).cancel
      end

      def delete_interim_message
        TelegramIntegration::DeleteMessage.call(
          chat_id:,
          message_id: interim_tg_message_id
        )
      end
    end
  end
end
