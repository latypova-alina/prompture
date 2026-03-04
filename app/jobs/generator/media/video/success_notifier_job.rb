module Generator
  module Media
    module Video
      class SuccessNotifierJob < ApplicationJob
        def perform(video_url, button_request_id)
          NotifySuccess::SuccessNotifier.call(video_url:, button_request_id:)
        end
      end
    end
  end
end
