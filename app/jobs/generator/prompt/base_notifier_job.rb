module Generator
  module Prompt
    class BaseNotifierJob < ApplicationJob
      include Memery

      private

      memoize def request
        ButtonExtendPromptRequest.includes(:parent_request, command_request: { user: :balance }).find(button_request_id)
      end

      memoize def locale
        request.user.locale.to_s
      end

      memoize def balance_credits
        request.user.balance.credits
      end
    end
  end
end
