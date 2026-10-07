module MiniApp
  # Telegram Web renders mini apps in an iframe on web.telegram.org, so these pages must be frameable by it.
  # The rest of the app keeps the default X-Frame-Options: SAMEORIGIN.
  class BaseController < ApplicationController
    TELEGRAM_WEB_ORIGIN = "https://web.telegram.org".freeze

    layout false

    content_security_policy do |policy|
      policy.frame_ancestors :self, TELEGRAM_WEB_ORIGIN
    end

    after_action :allow_framing

    private

    def allow_framing
      response.headers.delete("X-Frame-Options")
    end
  end
end
