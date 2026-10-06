# The test ClientStub overrides #request without calling super, so it skips the instrumentation
# prepended to Telegram::Bot::Client. Prepend it here too so request specs record outgoing calls.
require "telegram/bot/client_stub"

Telegram::Bot::ClientStub.prepend(ChatEvents::ClientInstrumentation)
