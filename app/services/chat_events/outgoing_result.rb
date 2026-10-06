module ChatEvents
  # The message(s) an outgoing Bot API call returned. The real client returns parsed JSON
  # ({"ok" => true, "result" => ...}); anything else (e.g. a test stub) just means no messages.
  class OutgoingResult
    include Memery

    def initialize(result)
      @result = result
    end

    memoize def message_ids
      Array.wrap(returned).filter_map { |message| message["message_id"] if message.is_a?(Hash) }
    end

    private

    attr_reader :result

    def returned
      result["result"] if result.is_a?(Hash)
    end
  end
end
