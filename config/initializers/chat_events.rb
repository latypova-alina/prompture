# Record every outgoing Bot API call in chat_events (see ChatEvents::ClientInstrumentation).
# Prepended once at boot, not in to_prepare: a reload would otherwise prepend a fresh copy and
# record each call twice. The module looks up ChatEvents::OutgoingRecorder per call, so the
# recorder itself still reloads in development.
Rails.application.config.after_initialize do
  Telegram::Bot::Client.prepend(ChatEvents::ClientInstrumentation)
end
