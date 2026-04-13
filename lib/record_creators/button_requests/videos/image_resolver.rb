module RecordCreators
  module ButtonRequests
    module Videos
      class ImageResolver
        MAX_IMAGE_URL_WAIT_ATTEMPTS = Rails.env.test? ? 1 : 8
        IMAGE_URL_WAIT_INTERVAL_SECONDS = 1

        def initialize(parent_request)
          @parent_request = parent_request
        end

        def image_url
          MAX_IMAGE_URL_WAIT_ATTEMPTS.times do |attempt|
            return resolved_image_url if resolved_image_url.present?

            sleep(IMAGE_URL_WAIT_INTERVAL_SECONDS) if attempt < MAX_IMAGE_URL_WAIT_ATTEMPTS - 1
          end

          nil
        end

        private

        attr_reader :parent_request

        def resolved_image_url
          parent_request.reload.resolved_image_url
        end
      end
    end
  end
end
