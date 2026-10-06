module ChatEvents
  # Records one outgoing Bot API call, for chat-scoped methods only. Infrastructure calls
  # (setMyCommands, setWebhook, createInvoiceLink...) and messages to the admin chat are skipped.
  # Never raises: a failed history row must not break the send.
  class OutgoingRecorder
    include Memery

    RECORDED_METHODS = %w[
      sendMessage sendPhoto sendVideo sendAudio sendVoice sendDocument sendAnimation sendMediaGroup sendInvoice
      editMessageText editMessageCaption editMessageReplyMarkup editMessageMedia deleteMessage answerCallbackQuery
    ].freeze

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
      return unless recordable?

      ChatEvent.insert(outgoing_call.attributes(chat_id:).merge(user_id:))
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :action, :body, :result, :error

    def recordable?
      RECORDED_METHODS.include?(action) && chat_id.present? && !admin_chat?
    end

    memoize def outgoing_call
      ChatEvents::OutgoingCall.new(action:, body:, result:, error:)
    end

    memoize def chat_id
      return callback_chat_id if action == "answerCallbackQuery"

      Integer(body[:chat_id], exception: false)
    end

    # answerCallbackQuery has no chat_id; find it through the callback_query we recorded on the way in.
    def callback_chat_id
      ChatEvent.where(direction: "incoming", kind: "callback_query")
               .where("payload->>'callback_query_id' = ?", body[:callback_query_id].to_s)
               .pick(:chat_id)
    end

    def admin_chat?
      chat_id.to_s == ENV["ADMIN_CHAT_ID"].to_s
    end

    def user_id
      User.where(chat_id:).pick(:id)
    end
  end
end
