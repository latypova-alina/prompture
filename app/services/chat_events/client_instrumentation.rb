module ChatEvents
  # Prepended to Telegram::Bot::Client (config/initializers/chat_events.rb): every outgoing call -
  # Telegram.bot.* in jobs/services, respond_with in the controller, presenters, MessageDeleter... -
  # ends in #request, so this one choke point records them all.
  module ClientInstrumentation
    def request(action, body = {})
      result = super
      ChatEvents::OutgoingRecorder.call(action:, body:, result:)
      result
    rescue Telegram::Bot::Error => e
      ChatEvents::OutgoingRecorder.call(action:, body:, error: e)
      raise
    end
  end
end
