module MediaGenerator
  module ButtonHandler
    class FindParentRequest
      include Interactor
      include Memery

      delegate :chat_id, :tg_message_id, to: :context

      def call
        context.fail!(error: ParentNotFoundError) unless parent

        context.parent_request = parent_request
      end

      delegate :request, to: :parent, prefix: true

      private

      memoize def parent
        BotTelegramMessage.find_by(tg_message_id:, chat_id:)
      end
    end
  end
end
