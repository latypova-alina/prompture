module ButtonHandler
  class FindParentRequest
    include Interactor
    include Memery

    delegate :chat_id, :tg_message_id, to: :context

    def call
      context.parent_request = parent_request
    end

    private

    memoize def parent_request
      TelegramMessage.find_by(tg_message_id:, chat_id:).request
    end
  end
end
