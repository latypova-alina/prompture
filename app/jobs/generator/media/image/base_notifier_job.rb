module Generator
  module Media
    module Image
      class BaseNotifierJob < ApplicationJob
        include WithLocaleInterface

        private

        def request_class
          ButtonImageProcessingRequest
        end
      end
    end
  end
end
