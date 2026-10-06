module ChatEvents
  # Reads one outgoing Bot API call (method + request body + result or error) into chat_event attributes.
  class OutgoingCall
    include Memery

    def initialize(action:, body:, result:, error:)
      @action = action.to_s
      @body = body.to_h.deep_stringify_keys
      @result = result
      @error = error
    end

    def attributes(chat_id:)
      {
        chat_id:, direction: "outgoing", kind: action, occurred_at: Time.current,
        tg_message_id:, reply_to_message_id:, text:, payload:
      }
    end

    private

    attr_reader :action, :body, :result, :error

    delegate :message_ids, to: :outgoing_result

    memoize def outgoing_result
      ChatEvents::OutgoingResult.new(result)
    end

    # The message the call created (send*) or targeted (edit*/deleteMessage).
    def tg_message_id
      message_ids.first || body["message_id"]
    end

    def reply_to_message_id
      body["reply_to_message_id"] || body.dig("reply_parameters", "message_id")
    end

    def text
      body["text"] || body["caption"]
    end

    def payload
      ChatEvents::OutgoingPayload.new(body:, message_ids:, error:).to_h
    end
  end
end
