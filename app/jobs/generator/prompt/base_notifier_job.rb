module Generator
  module Prompt
    class BaseNotifierJob < ApplicationJob
      include Memery

      private

      memoize def request
        ButtonExtendPromptRequest.includes(:parent_request, command_request: :user).find(button_request_id)
      end

      memoize def locale
        request.user.locale.to_s
      end
    end
  end
end
