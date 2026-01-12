module Generator
  module Prompt
    class UpdateButtonRequestJob
      include Sidekiq::Job

      def perform(extended_prompt, button_request_id)
        ButtonExtendPromptRequest.find(button_request_id).update!(extended_prompt:, status: "COMPLETED")
      end
    end
  end
end
