module ChatEvents
  # The user behind a chat, if they have an account yet (events are recorded either way).
  module UserLookup
    def self.call(chat_id)
      User.where(chat_id:).pick(:id)
    end
  end
end
