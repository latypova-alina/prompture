module ChatEvents
  # Reads one outgoing Bot API call (method + request body + result or error) into chat_event
  # attributes, keeping only an allowlist of body fields.
  class OutgoingCall
    include Memery

    BODY_FIELDS = %w[parse_mode reply_markup photo video audio voice document animation show_alert url
                     title description payload currency prices].freeze

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

    # The real client returns parsed JSON ({"ok" => true, "result" => ...}); anything else (e.g. a
    # test stub) just means there's no returned message to point at.
    memoize def returned
      result["result"] if result.is_a?(Hash)
    end

    def returned_messages
      Array.wrap(returned).select { |message| message.is_a?(Hash) }
    end

    # The message the call created (send*) or targeted (edit*/deleteMessage).
    def tg_message_id
      returned_messages.first&.dig("message_id") || body["message_id"]
    end

    def reply_to_message_id
      body["reply_to_message_id"] || body.dig("reply_parameters", "message_id")
    end

    def text
      body["text"] || body["caption"]
    end

    def payload
      body.slice(*BODY_FIELDS).transform_values { |value| serializable(value) }
          .merge(media_group_payload, message_ids_payload, error_payload)
    end

    # Uploaded files (IO) can't be stored - just note that something was uploaded.
    def serializable(value)
      value.respond_to?(:read) ? "(upload)" : value
    end

    def media_group_payload
      return {} unless body["media"].is_a?(Array)

      { "media" => body["media"].map { |item| item.to_h.stringify_keys.slice("type", "media", "caption") } }
    end

    def message_ids_payload
      ids = returned_messages.filter_map { |message| message["message_id"] }
      ids.size > 1 ? { "message_ids" => ids } : {}
    end

    def error_payload
      error ? { "error" => { "class" => error.class.name, "message" => error.message } } : {}
    end
  end
end
