module ChatEvents
  # Records one outgoing Bot API call into the conversation history. Never raises: a failed history
  # row must not break the send, so failures go to Sentry instead.
  class OutgoingRecorder
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(action:, body:, result: nil, error: nil)
      @action = action.to_s
      @body = body.to_h.with_indifferent_access
      @result = result
      @error = error
    end

    def call
      return unless ChatEvents::OutgoingFilter.recorded_method?(action)
      return unless ChatEvents::OutgoingFilter.recorded_chat?(chat_id)

      ChatEvent.insert(attributes)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :action, :body, :result, :error

    memoize def chat_id
      ChatEvents::OutgoingChat.new(action:, body:).chat_id
    end

    def attributes
      ChatEvents::OutgoingCall.new(action:, body:, result:, error:).attributes(chat_id:)
                              .merge(user_id: ChatEvents::UserLookup.call(chat_id))
    end
  end
end
