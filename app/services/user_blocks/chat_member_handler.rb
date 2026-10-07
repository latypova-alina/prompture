module UserBlocks
  # Applies a my_chat_member update from a private chat: Telegram sends "kicked" when the user
  # blocks the bot and "member" when they unblock it (or press Start again).
  class ChatMemberHandler
    include Memery

    BLOCKED = "kicked".freeze
    UNBLOCKED = "member".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(chat_member)
      @chat_member = chat_member
    end

    def call
      return unless private_chat?
      return if user.nil?

      case status
      when BLOCKED then user.update!(blocked_at: Time.zone.at(chat_member["date"]))
      when UNBLOCKED then user.update!(blocked_at: nil)
      end
    end

    private

    attr_reader :chat_member

    def private_chat?
      chat_member.dig("chat", "type") == "private"
    end

    def status
      chat_member.dig("new_chat_member", "status")
    end

    memoize def user
      User.find_by(chat_id: chat_member.dig("chat", "id"))
    end
  end
end
