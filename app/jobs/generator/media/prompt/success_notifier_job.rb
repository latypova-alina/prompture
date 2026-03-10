module Generator
  module Media
    module Prompt
      class SuccessNotifierJob < ApplicationJob
        def perform(extended_prompt, button_request_id)
          NotifySuccess::SuccessNotifier.call(extended_prompt:, button_request_id:)
        end
      end
    end
  end
end
