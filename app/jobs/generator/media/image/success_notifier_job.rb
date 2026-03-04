module Generator
  module Media
    module Image
      class SuccessNotifierJob < ApplicationJob
        def perform(image_url, button_request_id)
          NotifySuccess::SuccessNotifier.call(image_url:, button_request_id:)
        end
      end
    end
  end
end
