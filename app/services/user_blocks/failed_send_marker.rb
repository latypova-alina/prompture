module UserBlocks
  # Marks the chat's user as blocked when an outgoing call fails because they blocked the bot.
  # Catches users who blocked before my_chat_member was handled. Never raises: the caller
  # re-raises the original error, and a failed mark must not replace it.
  class FailedSendMarker
    BLOCKED_DESCRIPTION = "bot was blocked by the user".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(body:, error:)
      @body = body.to_h.with_indifferent_access
      @error = error
    end

    def call
      return unless blocked_error?
      return if chat_id.nil?

      User.where(chat_id:, blocked_at: nil).update_all(blocked_at: Time.current)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :body, :error

    def blocked_error?
      error.is_a?(Telegram::Bot::Forbidden) && error.message.include?(BLOCKED_DESCRIPTION)
    end

    def chat_id
      Integer(body[:chat_id], exception: false)
    end
  end
end
