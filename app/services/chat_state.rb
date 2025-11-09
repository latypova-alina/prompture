class ChatState
  class << self
    def set(chat_id, key, value)
      Sidekiq.redis { |r| r.set("chat:#{chat_id}:#{key}", value) }
    end

    def get(chat_id, key)
      Sidekiq.redis { |r| r.get("chat:#{chat_id}:#{key}") }
    end

    def del(chat_id, key)
      Sidekiq.redis { |r| r.del("chat:#{chat_id}:#{key}") }
    end
  end
end
