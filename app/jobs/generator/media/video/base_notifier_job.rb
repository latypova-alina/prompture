module Generator
  module Media
    module Video
      class BaseNotifierJob < ApplicationJob
        include WithLocaleInterface

        private

        def request_class
          ButtonVideoProcessingRequest
        end
      end
    end
  end
end
