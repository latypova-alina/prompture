module ChatEvents
  # The chat an outgoing call belongs to. Most methods carry chat_id; answerCallbackQuery doesn't,
  # so it's found through the callback_query recorded on the way in.
  class OutgoingChat
    def initialize(action:, body:)
      @action = action
      @body = body
    end

    def chat_id
      return callback_chat_id if action == "answerCallbackQuery"

      Integer(body[:chat_id], exception: false)
    end

    private

    attr_reader :action, :body

    def callback_chat_id
      ChatEvent.where(direction: "incoming", kind: "callback_query")
               .where("payload->>'callback_query_id' = ?", body[:callback_query_id].to_s)
               .pick(:chat_id)
    end
  end
end
