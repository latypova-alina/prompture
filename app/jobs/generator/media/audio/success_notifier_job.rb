module Generator
  module Media
    module Audio
      class SuccessNotifierJob < ApplicationJob
        def perform(audio_url, button_request_id)
          NotifySuccess::SuccessNotifier.call(audio_url:, button_request_id:)
        end
      end
    end
  end
end
